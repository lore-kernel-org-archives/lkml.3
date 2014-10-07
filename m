Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaJGRyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:54:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52234 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaJGRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:54:47 -0400
Message-ID: <543428E1.7050702@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 13:54:41 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Peter Huewe <PeterHuewe@gmx.de>
CC: keyrings@linux-nfs.org, jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit @ LinuxCon Europe
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07> <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
In-Reply-To: <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100717-0017-0000-0000-0000056826C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 12:42 PM, Andy Lutomirski wrote:
> On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
>> Hi,
>>
>> I would like to 'invite' all interested parties in a short TPM minisummit where we can discuss the following hot topics of the TPM subsystem over a beer or two:
>>   - State of the TPM Subsystem
>>   - De-/Initialization Mess
>>   - Devm'ification
>>   - Testing
>>   - TPM 2.0 Support
>>   - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
>>   - Status of old 1.1b TPM drivers, deprecation plans
>>   - ...
>>
> I am unlikely to be there, but I have a feature request / food for thought:
>
> Using a mandatory userspace daemon (e.g. trousers) for TPM access
> sucks.  Might it be possible to teach the kernel to handle context
> save and restore and let multiple processes open the device at once?
> Then a daemon wouldn't be necessary.

Why add the complexity of swapping of authenticated sessions and keys 
into the kernel if you can handle this in userspace? You need a library 
that is aware of the number of key slots and slots for sessions in the 
TPM and swaps them in at out when applications need them. Trousers is 
such a library that was designed to cope with the limitations of the 
device and make its functionality available to all applications that 
want to access it.

    Stefan

>
> There would still be a need for some policy (e.g. who can clear the
> SRK), but that should be manageable.  Maybe there should be two device
> nodes.  /dev/tpm_unpriv would be fully virtualized for access by
> multiple processes, but it would only allow use of the key hierarchy
> and read access to PCRs.  /dev/tpm_priv would allow NV access, PCR
> writes, SRK clears, etc.
>
> --Andy
>
>> Please register your interest by filling out this doodle
>>   http://doodle.com/q9ezcrivhqrktw6u
>>
>> I'm not sure if I can get any funding for the summit... but maybe I can arrange something.
>>
>>
>> Also I'm trying to bring along some TPM samples from my employer if possible.
>>
>>
>> Thanks
>> Peter
>>
>> p.s.: experienced kernel developers welcome :)
>> _______________________________________________
>> Ksummit-discuss mailing list
>> Ksummit-discuss@lists.linuxfoundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
> ------------------------------------------------------------------------------
> Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
> Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
> Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
> Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
> http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
> _______________________________________________
> TrouSerS-tech mailing list
> TrouSerS-tech@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/trousers-tech
>


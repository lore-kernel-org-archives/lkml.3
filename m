Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaJGSrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:47:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55320 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaJGSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:47:13 -0400
Message-ID: <5434352A.6080403@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 14:47:06 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Andy Lutomirski <luto@amacapital.net>, Peter Huewe <PeterHuewe@gmx.de>,
        keyrings@linux-nfs.org, jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit
 @ LinuxCon Europe
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07> <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com> <543428E1.7050702@linux.vnet.ibm.com> <20141007180209.GD10432@obsidianresearch.com>
In-Reply-To: <20141007180209.GD10432@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100718-1344-0000-0000-000004C0FE85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 02:02 PM, Jason Gunthorpe wrote:
> On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:
>
>> Why add the complexity of swapping of authenticated sessions and keys
>> into the kernel if you can handle this in userspace? You need a library
>> that is aware of the number of key slots and slots for sessions in the
>> TPM and swaps them in at out when applications need them. Trousers is
>> such a library that was designed to cope with the limitations of the
>> device and make its functionality available to all applications that
>> want to access it.
> How does trousers work with the kernel when the kernel is also using
> TPM key slots for IMA/keyring/whatever?

IIRC it only uses a single key slot and swaps all keys in and out of 
that one. If the kernel was to fill up all key (and sessions) slots, TSS 
would probably not work anymore.

Another argument for the TSS is that you also wouldn't want applications 
to swap out each others keys and sessions and leave them out or assume 
that they would always cleanup if they do not currently need them.

Regards,
    Stefan


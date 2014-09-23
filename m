Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaIWQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:42:56 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:35711 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaIWQmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Sep 2014 09:42:33 -0700
Message-ID: <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
Subject: Re: [Ksummit-discuss] TPM MiniSummit @ LinuxCon Europe
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: linux-ima-devel@lists.sourceforge.net, trousers-tech@lists.sourceforge.net,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        jarkko.sakkinnen@linux.intel.com, keyrings@linux-nfs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 22, 2014 2:07 AM, "Peter Huewe" <PeterHuewe@gmx.de> wrote:
>
> Hi,
>
> I would like to 'invite' all interested parties in a short TPM minisummit where we can discuss the following hot topics of the TPM subsystem over a beer or two:
>  - State of the TPM Subsystem
>  - De-/Initialization Mess
>  - Devm'ification
>  - Testing
>  - TPM 2.0 Support
>  - Dependencies / interaction with other subsystems (e.g. keyring / IMA)
>  - Status of old 1.1b TPM drivers, deprecation plans
>  - ...
>

I am unlikely to be there, but I have a feature request / food for thought:

Using a mandatory userspace daemon (e.g. trousers) for TPM access
sucks.  Might it be possible to teach the kernel to handle context
save and restore and let multiple processes open the device at once?
Then a daemon wouldn't be necessary.

There would still be a need for some policy (e.g. who can clear the
SRK), but that should be manageable.  Maybe there should be two device
nodes.  /dev/tpm_unpriv would be fully virtualized for access by
multiple processes, but it would only allow use of the key hierarchy
and read access to PCRs.  /dev/tpm_priv would allow NV access, PCR
writes, SRK clears, etc.

--Andy

>
> Please register your interest by filling out this doodle
>  http://doodle.com/q9ezcrivhqrktw6u
>
> I'm not sure if I can get any funding for the summit... but maybe I can arrange something.
>
>
> Also I'm trying to bring along some TPM samples from my employer if possible.
>
>
> Thanks
> Peter
>
> p.s.: experienced kernel developers welcome :)
> _______________________________________________
> Ksummit-discuss mailing list
> Ksummit-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss

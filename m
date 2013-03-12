Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3CLHVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:21:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59384 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3CLHVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:21:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Li Zefan <lizefan@huawei.com>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <CAKgNAkg8+gx8K6W=g1LStESRO=vgtvQtt2Q-+LG5R6Tk3ncYZQ@mail.gmail.com>
Date: Tue, 12 Mar 2013 00:20:52 -0700
In-Reply-To: <CAKgNAkg8+gx8K6W=g1LStESRO=vgtvQtt2Q-+LG5R6Tk3ncYZQ@mail.gmail.com>
	(Michael Kerrisk's message of "Tue, 12 Mar 2013 08:07:44 +0100")
Message-ID: <87620xccdn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+J75ArGjgggzJrvR+l7uDwBpNK+1uptzg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: Documenting reboot(2) changes for PID namespace in 3.9
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Li,
>
> Regarding your commit 923c7538236564c46ee80c253a416705321f13e3 , I
> plan to apply the following patch to the reboot(2) manual page. Does
> it look okay to you?

You have documented the behavior as of 3.4.

The change in 3.9 is to allow that same behavior in a pid_namespace
created with a user namespace.  Aka in 3.9 the permission
check changed from capable(CAP_SYS_BOOT)  to ns_capable(pid_ns->user_ns, CAP_SYS_BOOT);

Eric

> Thanks,
>
> Michael
>
> diff --git a/man2/reboot.2 b/man2/reboot.2
> index 8347870..1c17b85 100644
> --- a/man2/reboot.2
> +++ b/man2/reboot.2
> @@ -24,7 +24,7 @@
>  .\" Modified, 27 May 2004, Michael Kerrisk <mtk.manpages@gmail.com>
>  .\"     Added notes on capability requirements
>  .\"
> -.TH REBOOT 2 2010-10-31 "Linux" "Linux Programmer's Manual"
> +.TH REBOOT 2 2013-03-12 "Linux" "Linux Programmer's Manual"
>  .SH NAME
>  reboot \- reboot or enable/disable Ctrl-Alt-Del
>  .SH SYNOPSIS
> @@ -147,6 +147,26 @@ For the i386 architecture, the additional
> argument does not do
>  anything at present (2.1.122), but the type of reboot can be
>  determined by kernel command-line arguments ("reboot=...") to be
>  either warm or cold, and either hard or through the BIOS.
> +.SS Behavior inside PID namespaces
> +.\" commit commit 923c7538236564c46ee80c253a416705321f13e3
> +Since Linux 3.9, when
               ^^^ 3.4
> +.BR reboot ()
> +is called from a PID namespace (see
> +.BR pid_namespaces (7))
> +other than the initial PID namespace,
> +the effect of the call is to send a signal to the namespace "init" process.
> +.BR LINUX_REBOOT_CMD_RESTART
> +and
> +.BR LINUX_REBOOT_CMD_RESTART2
> +cause a
> +.BR SIGHUP
> +signal to be sent.
> +.BR LINUX_REBOOT_CMD_POWER_OFF
> +and
> +.BR LINUX_REBOOT_CMD_HALT
> +cause a
> +.B SIGINT
> +signal to be sent.
>  .SH RETURN VALUE
>  For the values of
>  .I cmd

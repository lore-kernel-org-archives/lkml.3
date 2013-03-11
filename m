Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3CKNhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:37:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50002 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3CKNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:37:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Kees Cook <keescook@google.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <513DD49F.8010301@internode.on.net>
Date: Mon, 11 Mar 2013 06:37:09 -0700
In-Reply-To: <513DD49F.8010301@internode.on.net> (Arthur Marsh's message of
	"Mon, 11 Mar 2013 23:27:03 +1030")
Message-ID: <87obeqnjlm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+JZmf9Zk18mf4Prkf8pEgZ08R377w9XTc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arthur Marsh <arthur.marsh@internode.on.net>
X-Spam-Relay-Country: 
Subject: Re: fs: Limit sys_mount to only request filesystem modules prevents mount -t cifs from working
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arthur Marsh <arthur.marsh@internode.on.net> writes:

> Hi, I found that Linux kernel 3.9.0-rc2 would not mount a remote cifs
> filesystem, and ran a git bisect which identified the following
> commit:
>
> Is there a patch already present somewhere to fix this problem?
>

Grr.  It was in linux-next for nearly a week and I checked an double
checked that patch.

This should fix it. 

Eric


diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..3cf8a15 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -777,6 +777,7 @@ struct file_system_type cifs_fs_type = {
 	.kill_sb = cifs_kill_sb,
 	/*  .fs_flags */
 };
+MODULE_ALIAS_FS("cifs");
 const struct inode_operations cifs_dir_inode_ops = {
 	.create = cifs_create,
 	.atomic_open = cifs_atomic_open,

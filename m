Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3EVEeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:34:08 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:59631 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3EVEeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOuz-RjoQLD5mb1c5vbaNZ-H9cY7T5p1ZVLWwftwbCBcQ@mail.gmail.com>
References: <519AF05E.1050808@huawei.com>
	<CACVXFVMG73_OCJOJGWR0CCeoR3taXnj+PXXah0q7fyB=Y4vfwQ@mail.gmail.com>
	<CACVXFVOuz-RjoQLD5mb1c5vbaNZ-H9cY7T5p1ZVLWwftwbCBcQ@mail.gmail.com>
Date: Wed, 22 May 2013 12:34:05 +0800
Message-ID: <CACVXFVPgLiFPSyLi48fa=RbyOantEu-jRynuuZFJ_4Lt5OSXYQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] ktap 0.1 released
From: Ming Lei <tom.leiming@gmail.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:19 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Wed, May 22, 2013 at 12:15 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Tue, May 21, 2013 at 11:56 AM, zhangwei(Jovi)
>>
>> Nice job, I have run it on ARM already with only one line change.
>>
>> But looks 'Control-C' can't stop the tracing or need some time to complete it,
>> see below:
>
> Sometimes, it doesn't work:
>
> $ sudo ./ktap ./scripts/kretprobe.kp
> ......
> vfs_read! (execname sshd); retval:38
> ^Cvfs_read! (execname sshd); retval:38
>
> probe ending
> vfs_read! (execname sshd); retval:48
> vfs_read! (execname sshd); retval:2
> ^C
> ^C^C^C
> ^C^C^C^C^C^C^C
>
> ^C^C^C^C^C^C

This one can be fixed by below patch, but can't work on
the last one.

diff --git a/vm.c b/vm.c
index c5f5733..a24a389 100644
--- a/vm.c
+++ b/vm.c
@@ -1060,7 +1060,7 @@ ktap_State *kp_newthread(ktap_State *mainthread)

 void kp_user_complete(ktap_State *ks)
 {
-	if (!ks || !G(ks)->user_completion)
+	if (!ks || !G(ks) || !G(ks)->user_completion)
 		return;

 	complete(G(ks)->user_completion);



Thanks,
-- 
Ming Lei

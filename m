Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3HFD2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:28:46 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44144 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3HFD2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:28:44 -0400
MIME-Version: 1.0
In-Reply-To: <51FA9902.3020708@schaufler-ca.com>
References: <51F16CFB.6040603@schaufler-ca.com>
	<CAKTCnzm7eipNPc22=NfOm3X7+ECu1zfckEyjBK+RDY69EZZeDw@mail.gmail.com>
	<51FA9902.3020708@schaufler-ca.com>
Date: Tue, 6 Aug 2013 08:58:43 +0530
Message-ID: <CAKTCnz=A6n-RfPHtNWx2-quc0vwi=qjA86JYM9t5E9SqF-=e4g@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
From: Balbir Singh <bsingharora@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 10:51 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 7/31/2013 7:48 PM, Balbir Singh wrote:
>> On Thu, Jul 25, 2013 at 11:52 PM, Casey Schaufler
>> <casey@schaufler-ca.com> wrote:
>>> Subject: [PATCH v14 0/6] LSM: Multiple concurrent LSMs
>>>
>>> Version 14 of this patchset is based on v3.10.
>>> It required significant change from version 13 due to changes
>>> in the audit code. It came out cleaner, especially in the changes
>>> to NetLabel. This version supports all existing LSMs running
>>> together at the same time. The combinations tested most completely
>>> are:
>>>
>>>     apparmor,tomoyo,smack,yama  - Ubuntu
>>>     apparmor,selinux,smack,yama - Fedora
>>>
>> Does this change the way one would develop a new LSM module? I presume
>> it does not
>
> The change that LSM developers need to be aware of is the security blob
> abstraction. Instead of using cred->security, inode->i_security and the
> like the code needs to use lsm_get_cred() and lsm_set_cred() and similar
> functions.
>

OK

>>> I have been unable to figure out how to configure SELinux on
>>> Ubuntu and TOMOYO on Fedora. That's the only reason the list
>>> does not include all five LSMs at once. Combining LSMs that
>>> use networking is tricky, but can be done. There are changes
>>> coming from AppArmor that might make it even trickier, but
>>> that's a problem for the future.
>>>
>>>
>>> Change the infrastructure for Linux Security Modules (LSM)s from a
>>> single vector of hook handlers to a list based method for handling
>>> multiple concurrent modules. All combinations of existing LSMs
>>> are supported.
>>>
>>> The "security=" boot option takes a comma separated list of LSMs,
>>> registering them in the order presented. The LSM hooks will be
>>> executed in the order registered. Hooks that return errors are
>>> not short circuited. All hooks are called even if one of the LSM
>>> hooks fails. The result returned will be that of the last LSM
>>> hook that failed.
>>>
>> This is an important design trade-off. From my perspective I think you
>> might want to revisit this, today it sounds like effective security ==
>> all hooks process and allow the operation. In this world a lack of
>> proper policy/setting can make hooks fail. I've not yet looked at the
>> code, but you might want to revisit this.
>
> The result of an LSM hook will be failure if any of the LSMs
> indicates failure. The key here is that all of the LSM hooks
> get called even if it's known that the overall result is failure.
> This is done because many LSM hooks maintain internal state and
> shortcutting can disrupt that.
>

Thanks for clarifying

Balbir

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbbAVSrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:47:35 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35416 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAVSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:47:31 -0500
MIME-Version: 1.0
In-Reply-To: <54C13CBC.3050004@schaufler-ca.com>
References: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov>
	<20150122085150.GB1268@kroah.com>
	<54C13CBC.3050004@schaufler-ca.com>
Date: Thu, 22 Jan 2015 13:47:29 -0500
Message-ID: <CAB9W1A3B1e8X+VoFb+CNqUo=mH3eK1AdJjU2D7DvWjFdsywWgA@mail.gmail.com>
Subject: Re: [PATCH] Add security hooks to binder and implement the hooks for SELinux.
From: Stephen Smalley <stephen.smalley@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Stephen Smalley <sds@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>, arve@android.com,
        Nick Kralevich <nnk@google.com>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 1:09 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 1/22/2015 12:51 AM, Greg KH wrote:
>> On Wed, Jan 21, 2015 at 10:54:10AM -0500, Stephen Smalley wrote:
>>> Add security hooks to the binder and implement the hooks for SELinux.
>>> The security hooks enable security modules such as SELinux to implement
>>> controls over binder IPC.  The security hooks include support for
>>> controlling what process can become the binder context manager
>>> (binder_set_context_mgr), controlling the ability of a process
>>> to invoke a binder transaction/IPC to another process (binder_transaction),
>>> controlling the ability of a process to transfer a binder reference to
>>> another process (binder_transfer_binder), and controlling the ability
>>> of a process to transfer an open file to another process (binder_transfer_file).
>>>
>>> These hooks have been included in the Android kernel trees since Android 4.3.
>> Very interesting, I missed the fact that these were added in that tree,
>> thanks for digging it out and submitting it.
>>
>> I'd like some acks from some Android developers before I take these.
>> Or, if it's easier for them to go through the security tree, that's fine
>> with me as well.
>
> My only concern is that we're about to see a set of hooks proposed
> for kdbus as well, and it would be a shame if we had two sets of hooks
> that do roughly the same thing (ok, *very roughly*) introduced back to back.

Not sure how much commonality there truly is among them (based on the
last set of proposed kdbus lsm hooks that I saw, admittedly a while
ago) and modules may want to distinguish between the two
forms of IPC regardless.  The binder hooks have been in place in the
Android kernel trees for quite some time, so this patch is just making
the mainline binder driver consistent with what is already in Android.
If it turns out that there is significant duplication when the kdbus
lsm hooks land, I'd be happy to help coalesce them.

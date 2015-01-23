Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbbAWV4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:56:32 -0500
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:46741 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbbAWV4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:56:31 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MFfJcDUVM1kWI3xZTfK80BoqQoWNMXNgC7WafOqBo6y7e73
 2L9EvlV_8sC2nVJxMc24W0dygrU5d0UGpGRLiCLbdPC5tN1g..TkCrwMgP_w
 irrfc94HKG27F6M34loQ6sOpWOYxB4vKeHfLhH5daHCC.wUAlX0ZaVhCAyMg
 qQCd.SKmUx2QbuwR0jxBxgUbxIrnnB9ADKsmXHiBjDi394.PsQzsKgGqHEnK
 7CSlifVfmM9.k6g8YnqPj4gxIre909s7R3r2Xyqpy4Jhy4_dUtEMop8b3u6O
 iOfhtXIeILmr7Zrx67QheLG1EprvPll6zjYO9nfL7wUXd9LQL.hlRMbdanBI
 gSI6rcAy5AFl43mbfdpsm0A7hkclIqWffVOVhoD0esPnXFW3HltdAqiUyhUv
 rnMn_IxmxklwreabUUuDaVGlaFoT3COUDE3OZJn4nrKp3ZY8NFKqch6g4ptR
 CE2kHOcksJllrfxnjqy_H68Isy8h8HcQcj5mVy1DI68nGU.dIdA29G6szyYD
 IdS8Mx9XygMA_myPzigepHgQwK447Anet7Hrz2n1QfwP9747jyWiT
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54C2C38C.2000207@schaufler-ca.com>
Date: Fri, 23 Jan 2015 13:56:28 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Stephen Smalley <stephen.smalley@gmail.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>,
        Linux Kernel <linux-kernel@vger.kernel.org>, arve@android.com,
        Nick Kralevich <nnk@google.com>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Add security hooks to binder and implement the hooks
 for SELinux.
References: <1421855650-22522-1-git-send-email-sds@tycho.nsa.gov> <20150122085150.GB1268@kroah.com> <54C13CBC.3050004@schaufler-ca.com> <CAB9W1A3B1e8X+VoFb+CNqUo=mH3eK1AdJjU2D7DvWjFdsywWgA@mail.gmail.com> <20150123023045.GA17138@kroah.com>
In-Reply-To: <20150123023045.GA17138@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2015 6:30 PM, Greg KH wrote:
> On Thu, Jan 22, 2015 at 01:47:29PM -0500, Stephen Smalley wrote:
>> On Thu, Jan 22, 2015 at 1:09 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 1/22/2015 12:51 AM, Greg KH wrote:
>>>> On Wed, Jan 21, 2015 at 10:54:10AM -0500, Stephen Smalley wrote:
>>>>> Add security hooks to the binder and implement the hooks for SELinux.
>>>>> The security hooks enable security modules such as SELinux to implement
>>>>> controls over binder IPC.  The security hooks include support for
>>>>> controlling what process can become the binder context manager
>>>>> (binder_set_context_mgr), controlling the ability of a process
>>>>> to invoke a binder transaction/IPC to another process (binder_transaction),
>>>>> controlling the ability of a process to transfer a binder reference to
>>>>> another process (binder_transfer_binder), and controlling the ability
>>>>> of a process to transfer an open file to another process (binder_transfer_file).
>>>>>
>>>>> These hooks have been included in the Android kernel trees since Android 4.3.
>>>> Very interesting, I missed the fact that these were added in that tree,
>>>> thanks for digging it out and submitting it.
>>>>
>>>> I'd like some acks from some Android developers before I take these.
>>>> Or, if it's easier for them to go through the security tree, that's fine
>>>> with me as well.
>>> My only concern is that we're about to see a set of hooks proposed
>>> for kdbus as well, and it would be a shame if we had two sets of hooks
>>> that do roughly the same thing (ok, *very roughly*) introduced back to back.
>> Not sure how much commonality there truly is among them (based on the
>> last set of proposed kdbus lsm hooks that I saw, admittedly a while
>> ago) and modules may want to distinguish between the two
>> forms of IPC regardless.  The binder hooks have been in place in the
>> Android kernel trees for quite some time, so this patch is just making
>> the mainline binder driver consistent with what is already in Android.
>> If it turns out that there is significant duplication when the kdbus
>> lsm hooks land, I'd be happy to help coalesce them.
> Yeah, I would wait and see what happens with how the kdbus hooks look
> before worrying about this all that much.  As people are using the
> binder hooks today, and binder is in the kernel tree, but kdbus isn't,
> let's not worry about kdbus until that is merged.

That seems like a sane plan to me in light of the situation. I am somewhat
concerned about the growth in special case security behavior. The tun hooks,
now the binder hooks and later the kdbus hooks. It looks like we're going
in the direction of special policies for each kind of communication rather
than a system IPC policy. On the other hand, that appears to be the trend in
system security overall, so even I can see that it may be prudent.


>
> thanks,
>
> greg k-h
>


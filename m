Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbbAINGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:06:51 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43069 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbAINGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <2354586.80TRdrKbtf@sifl>
References: <20150108190822.GB4365@codemonkey.org.uk>
	<3227891.DhTeT4XeAv@sifl>
	<2354586.80TRdrKbtf@sifl>
Date: Fri, 9 Jan 2015 08:06:49 -0500
Message-ID: <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com>
Subject: Re: noisy selinux messages on tmpfs mount.
From: Stephen Smalley <stephen.smalley@gmail.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, selinux <selinux@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Smalley <sds@epoch.ncsc.mil>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already reduced that message to KERN_DEBUG.  Is that not sufficient?

On Thu, Jan 8, 2015 at 2:39 PM, Paul Moore <pmoore@redhat.com> wrote:
> On Thursday, January 08, 2015 02:34:57 PM Paul Moore wrote:
>> On Thursday, January 08, 2015 02:08:22 PM Dave Jones wrote:
>> > systemd has started mounting a tmpfs in /run/user/<uid> every time a
>> > session begins.  So after ssh'ing into a box a number of times, dmesg
>> > looks like this..
>> >
>> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>>
>> {snip}
>>
>> > What's a good solution to stopping this spew ? printk_once doesn't seem
>> > like a good fit, in case someone is doing different labelling behaviours
>> > between mounts.
>> >
>> > Could we only print it if the mount is being done with non-default
>> > behaviour perhaps?
>>
>> I'm very curious to hear Stephen's opinion on the issue, but I wonder how
>> much this would honestly impact us if we removed this message in the case
>> where we mount the filesystem with a known labeling behavior.
>
> [NOTE: adding the SELinux list to the CC line.]
>
> --
> paul moore
> security @ redhat
>
> _______________________________________________
> Selinux mailing list
> Selinux@tycho.nsa.gov
> To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
> To get help, send an email containing "help" to Selinux-request@tycho.nsa.gov.

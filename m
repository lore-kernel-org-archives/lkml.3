Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab3DGQi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 12:38:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45753 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054Ab3DGQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 12:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130406175800.GA2033@kroah.com>
References: <20130406165600.GA29660@kroah.com> <20130406170952.GK4068@ZenIV.linux.org.uk>
 <20130406172612.GA27809@kroah.com> <20130406174512.GL4068@ZenIV.linux.org.uk> <20130406175800.GA2033@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 7 Apr 2013 18:38:37 +0200
Message-ID: <CAPXgP109T1TYParpR1xgB_vKo+C-mXDvWfJJfMEt98X2E1Fduw@mail.gmail.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 7:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Apr 06, 2013 at 06:45:12PM +0100, Al Viro wrote:
>> On Sat, Apr 06, 2013 at 10:26:12AM -0700, Greg KH wrote:
>>
>> > Why not?  "closed" systems, like Android and other embedded systems,
>> > have "assigned" uid and gid values that never change.  Right now they
>> > have to have a horrible shell-script to set these values in devtmpfs
>> > when the device shows up to the needed numbers.  This tiny patch gets
>> > rid of that shell script entirely, allowing them to specify it from the
>> > kernel as needed.
>>
>> What's to stop them from using static /dev?  Has an extra benefit of
>> getting rid of devtmpfs shite completely...
>
> True, it would, but they like using devtmpfs :)
>
> This change also allows systems that have "control" devices to properly
> be able to pass in the uid for the device they are creating, like rawctl
> (which I know is "obsolete"), and probably dm and lvm.  I thought loop
> devices might also want this, as they can now be created by normal
> users, but I don't think that's needed for them.

It is generally useful to be able to control the uid/gid of
userspace-initiated device nodes, instead of racy post-adjusting this
setting from udev rules with an unpredictable long window between the
request and the adjustment.

The created device node can inherit the ownership of the calling
process, in a similar way like we do for devpts.

We have the same for the mode already, and want to be able to do the
same for the other permissions properties.

Thanks,
Kay

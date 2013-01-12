Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3ALHXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 02:23:49 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52763 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3ALHXs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 02:23:48 -0500
Date: Sat, 12 Jan 2013 01:23:45 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Friendlier EPERM - Request for input
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com
In-Reply-To: <1357747463.2593.28.camel@localhost> (from eparis@redhat.com on
	Wed Jan  9 10:04:23 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1357975425.32505.6@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 10:04:23 AM, Eric Paris wrote:
> Getting an EPERM/EACCES in userspace really kinda blows.  As a user  
> you
> don't have any idea why you got it.  It could be SELinux, it could be
> rwx bits on the file, it could be a missing capability, it could be an
> ACL, it could be who knows what.

Adding SELinux, ACL, and capabilities to systems made them so much  
easier to comprehend, didn't it? (My definition of "secure" includes  
understanding what the system is doing. Crazy, I know.)

> We'd like to start figuring out the
> who knows what and hopefully find a way to expose that to userspace.

Obviously the response to having too many mechanisms doing the same  
thing (badly) is to add a management interface. Piled higher and deeper.

> But maybe those great minds on the lists can help me think of ways to
> get Friendlier denials that I haven't thought of.  Please.  What are  
> you
> thoughts, concerns, issues?

-EPERM was about file permissions. For SELinux and disability bits and  
whatever they're calling OS/2 extended attributes this week you need  
-EBUREAUCRACY.

Ken Thompson had the insight "files are just a flat sequence of bytes"  
about the same time he invented subdirectories. Bruce Horn shoehorned  
icon data into the Lisa filesystem metadata because they hadn't  
implemented subdirectories yet so they couldn't collate files that way,  
and apparently standard archive formats like "ELF" and "zip/jar" simply  
didn't occur to him. (Yes really:  
http://folklore.org/StoryView.py?project=Macintosh&story=The_Grand_Unified_Model_The_Finder.txt  
).

Copying Bruce's reversion of Ken's insight because Microsoft blindly  
copied Apple and now Windows doesn't know how to live without this  
crutch really doesn't fill me with confidence. Oh well, too late now...

> -Eric

Rob
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3EPJiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:38:04 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:18426 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3EPJiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:38:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsDAHColFFda1KP/2dsb2JhbAANTsF+gm0DAYETgxMBAQEEMgFGEAsNCwkWDwkDAgECAUUGDQEHAQGyW5JRjj9fB4NVA510jg8
Message-ID: <5194A8EA.8050403@draigBrady.com>
Date: Thu, 16 May 2013 10:37:46 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Eric Blake <eblake@redhat.com>
Subject: Re: RFC: allow empty symlink targets
References: <1358427833-3847-1-git-send-email-P@draigBrady.com> <50F8252C.2060404@draigBrady.com> <519381D8.5080206@draigBrady.com> <20130515220335.GV25399@ZenIV.linux.org.uk>
In-Reply-To: <20130515220335.GV25399@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 11:03 PM, Al Viro wrote:
> On Wed, May 15, 2013 at 01:38:48PM +0100, P??draig Brady wrote:
>>>> In today's Austin Group meeting, I was tasked to open a new bug that
>>>> would state specifically how the empty symlink is resolved; the intent
>>>> is to allow both Solaris behavior (current directory) and BSD behavior
>>>> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel
>>>> has a bug for rejecting the creation of an empty symlink, but once that
>>>> bug is fixed, then Linux can choose either Solaris or BSD behavior for
>>>> how to resolve such a symlink.
> 
> Austin Group Is At It Again, Demands at 11...
> 
> Would you mind explaining who's "everyone" and why would we possibly
> want to honour that agreement of yours?  Functionality in question is
> utterly pointless, seeing that semantics of such symlinks is OS-dependent
> anyway *and* that blanket refusal to traverse such beasts is a legitimate
> option.  What's the point in allowing to create them in the first place?

That's a fair point.
I guess the main reason to allow is for consistency with
other systems that do allow it.

What triggered this was a user who was using ln to
store "non file name" strings in symlinks,
and was surprised by the Linux error here,
and annoyed by the non portability of his script.

cheers,
Pádraig.

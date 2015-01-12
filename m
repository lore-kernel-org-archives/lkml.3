Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbbALUwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:52:04 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34580 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbALUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:52:01 -0500
From: Paul Moore <paul@paul-moore.com>
To: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rgb@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
Date: Mon, 12 Jan 2015 15:51:58 -0500
Message-ID: <2562166.o5FKhBijgA@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <14076510.2zuEr3QEsx@x2>
References: <20141007213054.GJ26201@madcap2.tricolour.ca> <201501121513.GAD65121.OOJQVSFFLOFMHt@I-love.SAKURA.ne.jp> <14076510.2zuEr3QEsx@x2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2015 10:14:34 AM Steve Grubb wrote:
> On Monday, January 12, 2015 03:13:12 PM Tetsuo Handa wrote:
> > This record contains multiple user-influenced comm names. If I use
> > audit_log_untrustedstring(), I would need to split this record into
> > multiple records like history[0]='...' history[1]='...' history[2]='...'
> > in order to avoid matching delimiters (i.e. ';', '=' and '>') used in
> > this record.
> 
> That sounds like a good change to me. Audit records are always name=value
> with a space between fields. We need this to always stay like this because
> the tooling expects that format. There is nowhere in the audit logs we use
> =>.

As a FYI, I'm putting a hold on any new audit messages for the time being so 
we can evaluate the current kernel audit API to determine the possibility of 
transitioning to a less ugly API.  I'll leave the door open for messages 
needed to fix bugs, but that's it.  If we do end up providing a new API and 
record format, I want to limit the number of message types in the existing 
API.

My apologies, but this is long overdue and the longer we wait the more 
difficult it will become.

-- 
paul moore
www.paul-moore.com


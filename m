Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaCNQML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNQMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:12:09 -0400
Date: Fri, 14 Mar 2014 17:12:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@redhat.com, jmario@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] perf: Speed up thread map generation
Message-ID: <20140314161206.GC5276@krava.redhat.com>
References: <1394808224-113774-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394808224-113774-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:43:44AM -0400, Don Zickus wrote:
> When trying to capture perf data on a system running spejbb2013,
> perf hung for about 15 minutes.  This is because it took that
> long to gather about 10,000 thread maps and process them.
> 
> I don't think a user wants to wait that long.
> 
> Instead, recognize that thread maps are roughly equivalent to
> pid maps and just quickly copy those instead.
> 
> To do this, I synthesize 'fork' events, this eventually calls
> thread__fork() and copies the maps over.
> 
> The overhead goes from 15 minutes down to about a few seconds.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> --
> V2: based on Jiri's comments, moved malloc up a level
>     and made sure the memory was freed

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

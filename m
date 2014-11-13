Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaKMOiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:38:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaKMOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:38:18 -0500
Date: Thu, 13 Nov 2014 08:38:10 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        jslaby@suse.cz, pmladek@suse.cz, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141113143810.GA502@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411131105290.10080@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411131105290.10080@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:16:00AM +0100, Miroslav Benes wrote:
> 
> Hi,
> 
> thank you for the first version of the united live patching core.
> 
> The patch below implements some of our review objections. Changes are 
> described in the commit log. It simplifies the hierarchy of data 
> structures, removes data duplication (lp_ and lpc_ structures) and 
> simplifies sysfs directory.
> 
> I did not try to repair other stuff (races, function names, function 
> prefix, api symmetry etc.). It should serve as a demonstration of our 
> point of view.
> 
> There are some problems with this. try_module_get and module_put may be 
> called several times for each kernel module where some function is 
> patched in. This should be fixed with module going notifier as suggested 
> by Petr. 
> 
> The modified core was tested with modified testing live patch originally 
> from Seth's github. It worked as expected.
> 
> Please take a look at these changes, so we can discuss them in more 
> detail.

Hi Miroslav,

Thanks for the code suggestions.

This is a single patch with three major changes, which makes it hard to
discuss each individual change on its own merits.

Also, Seth has already made a lot of changes already based on previous
comments, and is very close to having a v2 patch.  Because this patch is
so big, there are a lot of conflicts.

Can you wait for the v2 patch set and then post your own patch set
against it, with the patches split out so we can discuss them
individually?

-- 
Josh

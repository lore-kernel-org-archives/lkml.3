Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbbA0Pop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:44:45 -0500
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:59782 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374AbbA0Pom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:44:42 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3622:3865:3866:3868:3871:3872:3873:5007:6261:7875:7903:9010:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13161:13172:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: army06_45f41c7118553
X-Filterd-Recvd-Size: 1828
Date: Tue, 27 Jan 2015 10:44:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127104439.4bc62a60@gandalf.local.home>
In-Reply-To: <20150127101953.3245aaed@gandalf.local.home>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
	<20150126184314.24f2583c@gandalf.local.home>
	<20150127003742.GU29656@ZenIV.linux.org.uk>
	<20150126200218.6ecfc931@grimm.local.home>
	<20150126200350.471db2c0@grimm.local.home>
	<20150127043839.GW29656@ZenIV.linux.org.uk>
	<20150127101953.3245aaed@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 10:19:53 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> You mean, instead of grabbing trace_types_lock for modifying of events
> and trace arrays, we should grab the dentry->d_inode->i_mutex?
> 

OK, trace_arrays_lock protects against the tr->current_trace and the
list of arrays, and accessing it.

The creation of events is protected by the event_mutex. Which would
suffer the same issue, as it is grabbed when creating and removing
event directories.

-- Steve

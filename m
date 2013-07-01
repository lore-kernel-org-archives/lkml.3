Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3GALiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:38:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52651 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3GALiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:38:20 -0400
Message-ID: <51D16A27.8080002@hitachi.com>
Date: Mon, 01 Jul 2013 20:38:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] tracing: fix disabling of soft disable
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>  <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>  <51C43537.8070300@hitachi.com>  <1371847171.18733.128.camel@gandalf.local.home>  <1371849279.6453.44.camel@empanada> <1371878748.6453.82.camel@empanada>
In-Reply-To: <1371878748.6453.82.camel@empanada>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/22 14:25), Tom Zanussi wrote:
> 
> Looking into this a bit more, I think the reason it hasn't bothered
> anyone until now is that it's been hidden by the existing
> event_enable_read() implementation, which doesn't show any soft disable
> state when the event is actually disabled, only when it's enabled.  So
> the case where SOFT_DISABLED is still set but the event is actually
> disabled gets hidden by the catch-all "0" case.
> 
> My new version of event_enable_read() does show the soft disabled state
> when the event is actually disabled, which is why I noticed it wasn't
> getting turned off, and led to the current patch.
> 
> Ironically, the reason I refactored the function in the first place was
> to add the '+' flag for triggers - redundant, yes, but useful for
> debugging, not quite in the way I planned though.  ;-)  (It might be
> that leaving the current function in place and remaining oblivious would
> be ok, too, since it doesn't seem to really cause much of a problem in
> any case...)
> 

Ah, I've just missed this. And indeed, if your event_enable_read() cleanup
patch changes the output, that is not actual cleanup patch.
I think you should merge this into [1/11] patch to avoid behavior change.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



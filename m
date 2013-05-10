Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3EJP3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:29:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42863 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3EJP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:29:17 -0400
Date: Fri, 10 May 2013 17:27:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: acme@infradead.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [RFC/PATCH] perf: Expand definition of sysfs format attribute
Message-ID: <20130510152738.GA885@dyad.programming.kicks-ass.net>
References: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 03:21:05PM +1100, Michael Ellerman wrote:
> Make it explicit that the format attributes may define overlapping bit
> ranges. Unfortunately this was left unspecified originally, and all the
> examples show non-overlapping ranges. I don't believe this is an ABI
> change, as we are defining something that was previously undefined, but
> others may disagree.
> 
> The POWER8 PMU would like to define overlapping ranges, as bit ranges in
> the event code have different meanings for certain events. It will also
> allow us to define an overarching "event" field, that encompasses all
> others.
> 
> As far as I can see perf is comfortable with this change, however I am
> not sure if there are any other users of the interface.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Jiri was going to collect to send to Ingo..

Acked-by: Peter Zijlstra <peterz@infradead.org>

> ---
>  Documentation/ABI/testing/sysfs-bus-event_source-devices-format |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> index 079afc7..77f47ff 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
> @@ -9,6 +9,12 @@ Description:
>  		we want to export, so that userspace can deal with sane
>  		name/value pairs.
>  
> +		Userspace must be prepared for the possibility that attributes
> +		define overlapping bit ranges. For example:
> +			attr1 = 'config:0-23'
> +			attr2 = 'config:0-7'
> +			attr3 = 'config:12-35'
> +
>  		Example: 'config1:1,6-10,44'
>  		Defines contents of attribute that occupies bits 1,6-10,44 of
>  		perf_event_attr::config1.
> -- 
> 1.7.10.4
> 

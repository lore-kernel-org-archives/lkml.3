Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3CVThL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:37:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:21116 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3CVThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:37:10 -0400
Message-ID: <514CB2E4.2030009@tilera.com>
Date: Fri, 22 Mar 2013 15:37:08 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Austad <haustad@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: ns2cycles must be called with preempt disabled.
References: <1363973871-13199-1-git-send-email-haustad@cisco.com>
In-Reply-To: <1363973871-13199-1-git-send-email-haustad@cisco.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2013 1:37 PM, Henrik Austad wrote:
> ns2cycles use per_cpu variables, and will, eventually, find its way into
> smp_processord_id(). The latter must be called with either preempt
> disabled, irq's off, from a thread locked to a single core or early in
> the bootprocess (according to debug_smp_processor_id())

A better fix would be to use __raw_get_cpu_var() in ns2cycles(), along with a comment saying that the frequency of the tile timer is the same on all cores, so it doesn't matter which copy of the per-cpu structure we look at.

I don't object to the performance hit of the preemption calls so much as the confusing aspect of why it appears we need to disable preemption to compute the value, but not to use it :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


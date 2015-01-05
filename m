Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbbAEJRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:17:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbbAEJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:17:10 -0500
Date: Mon, 5 Jan 2015 09:17:08 +0000
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        snitzer@redhat.com
Subject: Re: [dm-devel] Questions about the function, queue_empty in
 dm-cache-policy-mq.c
Message-ID: <20150105091707.GA11818@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	agk@redhat.com, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <54AA03E0.9020900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AA03E0.9020900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 10:24:16PM -0500, nick wrote:
> Greetings All,
> I have a few questions about the function I stated in the message for this email.
> 1. What is the issues with the CPU usage for this function?

At the moment it can perform up to NR_QUEUE_LEVELS (16) list_empty()
calls.  Which I consider too much work for a function that is called
frequently.

> 2. What hardware is this on ?

Irrelevant.

> 3. How scalable is this function in terms of NR_QUEUE_LEVELS and how many does it need to handle?

Linear.  NR_QUEUE_LEVELS is a compile time constant currently set to
16, and unlikely to change.

- Joe

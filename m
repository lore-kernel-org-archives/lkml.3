Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3IZPk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:40:27 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47355 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IZPkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:40:22 -0400
Date: Thu, 26 Sep 2013 11:40:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 09/27] mmc: mvsdio: Remove redundant suspend and resume
 callbacks
In-Reply-To: <1380207292-16968-10-git-send-email-ulf.hansson@linaro.org>
Message-ID: <alpine.LFD.2.03.1309261136010.312@syhkavp.arg>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org> <1380207292-16968-10-git-send-email-ulf.hansson@linaro.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Ulf Hansson wrote:

> Suspend and resume of cards are handled by the protocol layer and
> consequently the mmc_suspend|resume_host APIs are marked as deprecated.

Having the protocol layer take care of card suspend is perfectly sound.

However, what about host controllers?  Shouldn't they suspend themselves 
as well?  There is certainly potential for power saving by gating clocks 
to the host IP block or the like.


Nicolas

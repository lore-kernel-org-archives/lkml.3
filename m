Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCST24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:28:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33988 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaCST2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:28:54 -0400
Message-ID: <5329EFF0.6030400@wwwdotorg.org>
Date: Wed, 19 Mar 2014 13:28:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH] of: Make of_find_node_by_path() handle /aliases
References: <1395179549-31345-1-git-send-email-pantelis.antoniou@konsulko.com>
In-Reply-To: <1395179549-31345-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 03:52 PM, Pantelis Antoniou wrote:
> Make of_find_node_by_path() handle aliases as prefixes.
> 
> Originally by David Daney <ddaney@caviumnetworks.com>, but
> reworked according to remark by Grant Likely.
> 
> Handles all cases without allocating memory as requested by
> Grant Likely <grant.likely@linaro.org>

Why not just introduce a new function of_find_node_by_alias()? A single
unified function would make sense if the function did something like:
(1) find my path, and return if found (2) if not found, fall back to
searching /aliases. However, since this modified function takes 2
separate formats of input path based on whether it should search for an
alias or not, it seems like 2 separate functions would be a better API.
Perhaps the new API should simply be a wrapper around
of_find_node_by_path, once the alias has been found?

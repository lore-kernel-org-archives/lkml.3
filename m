Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaBSOPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:15:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62903 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaBSOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:15:00 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v4 0/4] Bugfix for of_match_node ordering
Date: Wed, 19 Feb 2014 14:14:46 +0000
Message-Id: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've taken Kevin's latest rework and done even more rework on it. :-) I
didn't quite like how it was looking so I rolled his scoring code
directly into __of_device_is_compatible() so that the function always
returns a score in a way that is still compatible with the existing
users (ie. non-zero == successful match). This eliminates the need for a
separate pscore argument and it also let me roll the type and name
checks into the same function. I'm a lot happier with it overall and it
makes for a slightly smaller number of lines of code changed. Please
take a look and give it a spin. This is basically a bug fix so I'll need
to push it out to Linus in the near future.

Acks and Tested-bys would be particularly appreciated.

Thanks,
g.

Kevin Hao (2):
	Revert "of: search the best compatible match first in __of_match_node()"
	of: reimplement the matching method for __of_match_node()

Grant Likely (2):
	of: Move testcase FDT data into drivers/of
	of: Add self test for of_match_node()



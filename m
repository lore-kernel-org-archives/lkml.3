Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaEGWwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:52:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61626 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaEGWwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:52:17 -0400
Message-ID: <536AB91F.3010302@gmail.com>
Date: Wed, 07 May 2014 15:52:15 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 0/4] DT platform device name collision fixes
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2014 2:48 PM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> This series fixes the device naming collisions that can occur with 
> nultiple devices having the same name and non-translatable unit 
> addresses. This issue was raised in this thread[1]. I intend to merge 
> this regardless of whether or not some hierarchy in sysfs is created. 
> That is really a separate issue independent of these fixes.
> 
> I found and fix a couple of other issues in the process of testing the 
> fix.
> 
> Rob
> 
> [1] https://lkml.org/lkml/2014/4/23/312
> 
> Rob Herring (4):
>   of/selftest: add testcase for nodes with same name and address
>   of/platform: return error on of_platform_device_create_pdata failure
>   of/platform: fix device naming for non-translatable addresses
>   of: kill off of_can_translate_address

My opinion is that this approach is not a good approach to solving the
problem.  It is papering over a symptom, instead of dealing with the
root cause.

But despite my opinion, you can add to patches 2-4 (I did not test
the self-test added in patch 1):

   Tested-by: Frank Rowand <frank.rowand@sonymobile.com>

The patches resolve the name conflict originally reported for the
qcomm PMIC, tested on 3.15-rc1, with a bunch of out of tree
patches.

-Frank


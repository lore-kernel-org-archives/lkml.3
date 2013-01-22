Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3AVKHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:07:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52672 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3AVKHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:07:09 -0500
Message-ID: <50FE64C8.8040407@ti.com>
Date: Tue, 22 Jan 2013 11:07:04 +0100
From: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <v-stehle@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regmap: debugfs: Fix compilation warning
References: <1358779015-25735-1-git-send-email-v-stehle@ti.com> <20130122064121.GC1766@opensource.wolfsonmicro.com>
In-Reply-To: <20130122064121.GC1766@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 07:41 AM, Mark Brown wrote:
(..)
> This sort of fix is not a good idea, you're just shutting the
> warning up without any sort of analysis explaining why it's
> generated in error.  If it's generating a spurious error that's a
> compiler bug.

In the regmap_debugfs_get_dump_start() function control flow, I think
the compiler cannot know for sure that the list_for_each_entry()
iterates at least once.:

	regmap_debugfs_get_dump_start()
	{
		unsigned int ret;
		<snip some code, which does not touch ret>

		list_for_each_entry() {
			<snip some code>
			ret = <value>;
		}

		return ret;
	}

Do you think there is a way to "mark" the list_for_each_entry() as
iterating at least once? an __attribute__ maybe?

Best regards,

V.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3EaPGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:06:32 -0400
Received: from muin.pair.com ([209.68.1.55]:50386 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab3EaPGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:06:25 -0400
Message-ID: <51A8BC83.6050809@tabi.org>
Date: Fri, 31 May 2013 10:06:43 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
References: <cover.1370004925.git.michal.simek@xilinx.com> <51A8A89C.8030404@tabi.org> <51A8B220.6070308@monstr.eu> <1466524.sgAzczhnBg@wuerfel>
In-Reply-To: <1466524.sgAzczhnBg@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 09:56 AM, Arnd Bergmann wrote:
> Yes, unfortunately, this is what all other frame buffer drivers do
> at the moment. It is technically not correct, but most architectures
> are able to call readl/writel on regular memory, or dereference
> __iomem tokens, so we often get away with it. It's probably not
> worth fixing it in the fbdev code base as that would be a huge
> change, and people are migrating to DRM/KMS.

But why bother fixing this bug if it just makes things worse?  Sparse is
supposed to warn us about bad code.  This patch doesn't fix the bug, it
just masks the warnings!

-- 
Timur Tabi

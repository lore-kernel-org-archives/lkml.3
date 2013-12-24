Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3LXMTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:19:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38181 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LXMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:19:23 -0500
Date: Tue, 24 Dec 2013 12:19:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131224121912.GX30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-8-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815830-8794-8-git-send-email-pawel.moll@arm.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 07/18] regmap: debugfs: Always create "registers" &
 "access" files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 04:23:39PM +0000, Pawel Moll wrote:
> When a map covers a single register, max_register is equal
> to 0, so the "registers" & "access" files were not created.
> 
> This patch is removing this restriction. It should be save,
> as the maps not without register 0 should return false
> for regmap_readable(map, 0).

No, we need to find a better way of doing this such as checking to see
if register zero is accessible in some way.  We want to avoid having
those files if there's no way of populating them since this is useful
information for tooling.

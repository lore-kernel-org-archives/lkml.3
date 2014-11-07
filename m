Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaKGNP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:15:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:9685 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaKGNP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:15:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485388063"
Message-ID: <1415366123.958.331.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix invalid vfree()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Fri, 07 Nov 2014 15:15:23 +0200
In-Reply-To: <1414367171-4657-1-git-send-email-richard@nod.at>
References: <1414367171-4657-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 00:46 +0100, Richard Weinberger wrote:
> The logic of vfree()'ing vol->upd_buf is tied to vol->updating.
> In ubi_start_update() vol->updating is set long before vmalloc()'ing
> vol->upd_buf. If we encounter a write failure in ubi_start_update()
> before vmalloc() the UBI device release function will try to vfree()
> vol->upd_buf because vol->updating is set.
> Fix this by allocating vol->upd_buf directly after setting vol->updating.

Pushed, thanks!


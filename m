Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaKFHvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:51:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:38616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaKFHvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:51:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="632459239"
Message-ID: <1415260306.958.158.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 08/35] UBI: Split __wl_get_peb()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Thu, 06 Nov 2014 09:51:46 +0200
In-Reply-To: <1414586758-9972-9-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
	 <1414586758-9972-9-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
> Make it two functions, wl_get_wle() and wl_get_peb().
> wl_get_peb() works exactly like __wl_get_peb() but wl_get_wle()
> does not call produce_free_peb().
> While refilling the fastmap user pool we cannot release ubi->wl_lock
> as produce_free_peb() does.
> Hence the fastmap logic uses now wl_get_wle().
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Please, re-consider naming.

The convention is that non-static function names start with ubi_wl_*.
Static function names start with _*.

Also, please add a comment above the functions explaining what it does.

Artem.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaKEPmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:42:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:42115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaKEPmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:42:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411868175"
Message-ID: <1415202120.958.123.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 05/35] UBI: Fastmap: Ensure that only one fastmap work
 is scheduled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 17:42:00 +0200
In-Reply-To: <1414586758-9972-6-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
	 <1414586758-9972-6-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
>  	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
>  	ubi_update_fastmap(ubi);
> +	spin_lock(&ubi->wl_lock);
> +	ubi->fm_work_scheduled = 0;
> +	spin_unlock(&ubi->wl_lock);
>  }

Why is the 'update_fastmap_work_fn()' function in wl.c? Can we move it
to fastmap.c?


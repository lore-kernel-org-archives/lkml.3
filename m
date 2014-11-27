Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaK0Q36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:29:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:22071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaK0Q34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:29:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,470,1413270000"; 
   d="scan'208";a="639149668"
Message-ID: <1417105793.5858.117.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 18:29:53 +0200
In-Reply-To: <54774C71.50807@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
		 <1416835236-25185-4-git-send-email-richard@nod.at>
	 <1417102739.5858.112.camel@sauron.fi.intel.com> <54774C71.50807@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:08 +0100, Richard Weinberger wrote:
> > Obviously, there is some misunderstanding. This looks like lack of
> > separation and misuse of layering. I am missing explanations why I am
> > wrong...
> 
> So you want me to use the UBI WL background thread for the scheduled fastmap work?

No. It is more like either use it or do not use it.

> I didn't do it that way because you said more than once that fastmap is fastmap and
> WL is WL. Therefore I've separated it.

And "separated" meaning adding this code to wl.c?

+#ifdef CONFIG_MTD_UBI_FASTMAP
+       flush_work(&ubi->fm_work);
+#endif

Could it be separated some more then?


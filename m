Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaKFIS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:18:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:6234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKFIS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:18:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="618060458"
Message-ID: <1415261925.958.177.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: hujianyang <hujianyang@huawei.com>, ezequiel.garcia@free-electrons.com,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 06 Nov 2014 10:18:45 +0200
In-Reply-To: <54566692.10504@codeaurora.org>
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
	 <5449C870.7060509@huawei.com> <54566692.10504@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-02 at 19:14 +0200, Tanya Brokhman wrote:
> >> +    ubi_err(ubi, "self-check failed for PEB %d", pnum);
> >> +    ubi_msg(ubi, "hex dump of the %d-%d region",
> >> +             offset, offset + len);
> >>      print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf,
> len, 1);
> >>      err = -EINVAL;
> >>   error:
> >
> > Artem, I know you have tried to align the message code in different
> lines, maybe
> > you can check if you lose this one.
> >
> 
> hmmm... not sure I understand what is wrong here....

It is more of a nit-pick, but we try to be consistent. Here is how we
align split messages:

  ubi_msg(ubi, "blah",
          XYZ)

and not

  ubi_msg(ubi, "blah",
            XYZ)

So we first use few tabs, and then some spaces to align. You use just
tabs. Sometimes the second line is aligned, sometimes it goes a bit
further.


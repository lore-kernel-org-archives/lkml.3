Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3CPN6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:58:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38918 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3CPN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:58:29 -0400
Date: Sat, 16 Mar 2013 16:58:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 33/50] staging: omap-thermal: refactor APIs handling
 threshold values
Message-ID: <20130316135821.GJ9189@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-34-git-send-email-eduardo.valentin@ti.com>
 <20130316083952.GO9138@mwanda>
 <51446A50.9070701@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51446A50.9070701@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 08:49:20AM -0400, Eduardo Valentin wrote:
> On 16-03-2013 04:39, Dan Carpenter wrote:
> >On Fri, Mar 15, 2013 at 09:00:21AM -0400, Eduardo Valentin wrote:
> >>  	if (ret) {
> >>  		dev_err(bg_ptr->dev, "failed to read thot\n");
> >>-		return -EIO;
> >>+		ret = -EIO;
> >>+		goto exit;
> >>  	}
> >>
> >>-	*thot = temp;
> >>+	*val = temp;
> >>
> >>+exit:
> >>  	return 0;
> >>  }
> >
> >
> >The bunny hop has introduced a bug and this always returns success.
> 
> What was the bug introduced?
> 
> I will send a patch to fix the return value.

Returning the wrong value *is* the bug.

regards,
dan carpenter


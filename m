Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3FQRmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:42:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42953 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754691Ab3FQRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:42:04 -0400
Message-ID: <1371490921.2213.5.camel@joe-AO722>
Subject: Re: [PATCH 1/4] silicom: checkpatch: assignments in if conditions
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lorenz Haspel <lorenz@badgers.com>, devel@linuxdriverproject.org,
        gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Date: Mon, 17 Jun 2013 10:42:01 -0700
In-Reply-To: <20130617172246.GI5008@mwanda>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
	 <20130617172246.GI5008@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 20:22 +0300, Dan Carpenter wrote:
> This will need to be redone because there were some buggy extra
> lines added toward the end of the patch.

[]

> > @@ -4867,10 +4884,12 @@ int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
> >  	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
> >  		if ((pbpctl_dev->bp_tpl_flag))
> >  			return BP_NOT_CAP;
> > -	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
> > -		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
> > -		    (pbpctl_dev_b->bp_tpl_flag))
> > -			return BP_NOT_CAP;
> > +	} else {
> > +		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
> > +		if (pbpctl_dev_b)
> > +			if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
> > +			    (pbpctl_dev_b->bp_tpl_flag))
> > +				return BP_NOT_CAP;
> 
> Please put curly brace {} around multi-line indents.  Even though
> they are not needed for semantic reasons they make the code more
> readable.

Better still would be to combine the multi-statement ifs
into a single test and avoid the braces altogether.

		if (pbpctl_dev_b &&
		    pbpctl_dev_b->bp_caps & TPL_CAP &&
		    pbpctl_dev_b->bp_tpl_flag)



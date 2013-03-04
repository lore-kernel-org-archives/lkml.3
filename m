Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3CDTAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:00:10 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:43288 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab3CDTAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:00:05 -0500
Date: Mon, 4 Mar 2013 11:59:52 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Peter Huewe <peter.huewe@infineon.com>, tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, shpedoikal@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v2] tpm: Add support for new Infineon I2C
 TPM (SLB 9645 TT 1.2 I2C)
Message-ID: <20130304185952.GA24196@obsidianresearch.com>
References: <1362408106-8632-1-git-send-email-peter.huewe@infineon.com>
 <20130304174104.GA10811@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304174104.GA10811@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:41:04AM -0600, Kent Yoder wrote:
> >  	.id_table = tpm_tis_i2c_table,
> >  	.probe = tpm_tis_i2c_probe,
> >  	.remove = tpm_tis_i2c_remove,
> > @@ -703,11 +759,12 @@ static struct i2c_driver tpm_tis_i2c_driver = {
> >  		   .name = "tpm_i2c_infineon",
> >  		   .owner = THIS_MODULE,
> >  		   .pm = &tpm_tis_i2c_ops,
> > +		   .of_match_table = of_match_ptr(tpm_tis_i2c_of_match),
> 
>   Please put this line inside an ifdef CONFIG_OF, since of_match_ptr
> lives in there.

The OF stuff is designed to hide the CONFIG_OF from using code, 
of_match_ptr(x) expends to NULL when CONFIG_OF is not set.

It is optional to include the MATCH_TABLE bit in a CONFI_OF #ifdef,
lots of places don't.

Jason

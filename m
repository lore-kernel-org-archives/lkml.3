Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaETWEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:04:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51428 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaETWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:04:47 -0400
Date: Wed, 21 May 2014 01:04:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>, devel@driverdev.osuosl.org,
        Stefan Hajnoczi <stefanha@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: toneport.c: Fix for possible null
 pointer dereference
Message-ID: <20140520220435.GR15585@mwanda>
References: <1400535540-5959-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400535540-5959-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:39:00PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This one is called from line6_disconnect() and the caller checks that
usb_get_intfdata(interface); returns non-NULL.  So it's messy code but
not a real bug.

For the lustre ones, I don't know if they are real bugs or not.

regards,
dan carpenter


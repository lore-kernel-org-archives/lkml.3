Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaD2KUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:20:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22193 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbaD2KUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:20:33 -0400
Date: Tue, 29 Apr 2014 13:20:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>
Subject: Re: [PATCH 30/47] staging/lustre/mdc: fix issue found by Klocwork
 Insight tool
Message-ID: <20140429102017.GA26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-31-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-31-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:54PM -0400, Oleg Drokin wrote:
> From: Dmitry Eremin <dmitry.eremin@intel.com>
> 
> Pointer 'mod' checked for NULL at line 160 may be dereferenced at line 208.
> 

This seems to be a real bug, btw.  For example, FSFILT_IOC_SETFLAGS
calls md_setattr() with a NULL mod in ll_iocontrol().

regards,
dan carpenter


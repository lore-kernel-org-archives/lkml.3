Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaCGIEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:04:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGIEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:04:24 -0500
Date: Fri, 7 Mar 2014 11:04:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: gregkh@linuxfoundation.org, valentina.manea.m@gmail.com,
        standby24x7@gmail.com, devel@driverdev.osuosl.org,
        chuansheng.liu@intel.com, dongxing.zhang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [staging][r8188eu]: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Message-ID: <20140307080411.GB29018@mwanda>
References: <1394222494.26112.32.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394222494.26112.32.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:01:34PM -0500, Wang, Xiaoming wrote:
> pcmd->parmbuf->pbuf has been allocated if command is GEN_CMD_CODE(_Set_Drv_Extra),
> and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by rtw_dequeue_cmd.
> The memory leak happened on this branch "if( _FAIL == rtw_cmd_filter(pcmdpriv, pcmd) )"
> which goto post_process directly against freeing pcmd->parmbuf->pbuf in
> rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
> This patch free pcmd->parmbuf->pbuf on forgotten branch to avoid memory leak.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>

This code looks completely different in linux-next.  Please redo on top
of linux-next if it's still needed.

regards,
dan carpenter


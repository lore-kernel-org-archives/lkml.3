Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaCRUBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:01:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501AbaCRUBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:01:51 -0400
Date: Tue, 18 Mar 2014 13:03:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: valentina.manea.m@gmail.com, dan.carpenter@oracle.com,
        standby24x7@gmail.com, devel@driverdev.osuosl.org,
        chuansheng.liu@intel.com, dongxing.zhang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: memory leak in rtw_free_cmd_obj if
 command is (_Set_Drv_Extra)
Message-ID: <20140318200353.GA24518@kroah.com>
References: <1395152727.31547.5.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395152727.31547.5.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:25:27AM -0400, Wang, Xiaoming wrote:
> pcmd->parmbuf->pbuf has been allocated if command is GEN_CMD_CODE(_Set_Drv_Extra),
> and it enqueued by rtw_enqueue_cmd. rtw_cmd_thread dequeue pcmd by rtw_dequeue_cmd.
> The memory leak happened on this branch "if( _FAIL == rtw_cmd_filter(pcmdpriv, pcmd) )"
> which goto post_process directly against freeing pcmd->parmbuf->pbuf in
> rtw_drvextra_cmd_hdl which is the cmd_hdl if command is (_Set_Drv_Extra).
> This patch free pcmd->parmbuf->pbuf on the forgotten branch to avoid memory leak.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>

You obviously didn't test this as it breaks the build :(

{sigh}

Please retry after 3.15-rc1 is out.

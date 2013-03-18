Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3CRKVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:21:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28328 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRKVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:21:35 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-0f-5146eaadc0ff
Message-id: <5146EAB0.1030705@samsung.com>
Date: Mon, 18 Mar 2013 19:21:36 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221
 Thunderbird/17.0.3
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363382956-14557-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zbd21r9wCDSatVbTYvC7eYt7Wo6wW
	219vZLM4u+wgm8WNX22sFpd3zWGzOPK/n9Hi1PXPbBYb7k5ltfhw/yKzxcJNh9gcuD1mN1xk
	8dg56y67x6Eraxk9rpxoYvWYvPAis0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBl3GqdwVTw
	Rqji9rmzrA2MHfxdjJwcEgImEov637FD2GISF+6tZ+ti5OIQEljGKNH67zZQggOsaEpvPkiN
	kMB0RokvG0wgal4ySjT9msAKkuAV0JL4PXUOE4jNIqAq8XTbREYQm01AR2L7t+NgcVGBMInZ
	188yQ9QLSvyYfI8FxBYR0JR41vCSGWQos8ATJonzq06AFQkLREt82nKIHWKzq8TlU8fBGjgF
	3CRWvrvHBmIzAy3Y3zoNypaX2LzmLdggCYG/7BKbu7tZIS4SkPg2+RALxDeyEpsOMEN8LClx
	cMUNlgmMYrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESsRN3MN4/
	YH2IMRlo5URmKdHkfGDE55XEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qB0Thh/X+7tX3yuu08ZpNW+7a/NVI9c8VMdIPaj1eVqzbumaFx0Nn1X377
	yif5zDEyHdJ+ZpMnr1O46Ja1y2rDcc5Vn0xPajqwzBOaefn9p5xpervk5uitSfqmGbL8q5p4
	ntfJhV9W7j/oFtuW/OrUC35rDt/WBN2EH7nl80v2vo1YxP5u2uNOQSWW4oxEQy3mouJEABTj
	mb3uAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd21r9wCDc6dlrLYvC7eYt7Wo6wW
	219vZLM4u+wgm8WNX22sFpd3zWGzOPK/n9Hi1PXPbBYb7k5ltfhw/yKzxcJNh9gcuD1mN1xk
	8dg56y67x6Eraxk9rpxoYvWYvPAis0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzLjVOoOp4I1Qxe1zZ1kbGDv4uxg5OCQETCSm9OZ3MXICmWISF+6t
	ZwOxhQSmM0p82WDSxcgFZL9klGj6NYEVJMEroCXxe+ocJhCbRUBV4um2iYwgNpuAjsT2b8fB
	4qICYRKzr59lhqgXlPgx+R4LiC0ioCnxrOElM8hQZoEnTBLnV50AKxIWiJb4tOUQO8RmV4nL
	p46DNXAKuEmsfHcP7CJmoAX7W6dB2fISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4HTyT2sG4ssHiEKMAB6MSD++O9W6BQqyJZcWVuYcYJTiYlUR4
	HW8DhXhTEiurUovy44tKc1KLDzEmA4NgIrOUaHI+MFXllcQbGpuYGVkamRmbmBsbkyasJM57
	oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjiZAdh67cvsVQ8/65iDlT95Q4gcmvL8U8y1nhkqgV
	EnX5772fCyMncx6W4PgZdt6K30Zctj7xfYvu0akXW7jiDnNGBKb9zt+WHix+0bV4ro17g9zG
	rlmuN7er/pfynFpaku5U43HaQ8PaX1DDm9v2fre66c+3B3leXVNgcmf61PFBLSbk5gMlluKM
	REMt5qLiRACSOoX7SwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Great..i have found the problem like this.
I will check your patch..and share the result.

Best Regards,
Jaehoon Chung

On 03/16/2013 06:29 AM, Doug Anderson wrote:
> On a flaky piece of hardware that seems good at generating CRC errors,
> we have found that often times the CRC errors don't get reported
> properly when using CONFIG_MMC_DW_IDMAC (they get reported OK when
> using pio).
> 
> The flow that happens is:
> 1. dw_mci_interrupt() fires and status=80b8, pending=8088 so that
>    we hit (pending & DW_MCI_DATA_ERROR_FLAGS).  We store 8088 in
>    data_status and set EVENT_DATA_ERROR in host->pending_events
> 2. We schedule the tasklet and it runs.
> 3. We're in STATE_SENDING_DATA in the tasklet and see
>    EVENT_DATA_ERROR so we dw_mci_stop_dma().
> 4. dw_mci_stop_dma() calls dw_mci_idmac_stop_dma() and
>    dw_mci_dma_cleanup().  These stop dma but _don't_ set
>    EVENT_XFER_COMPLETE (since we're host->using_dma).
> 5. data->stop is NULL so we don't send a stop command.
> 6. We move onto STATE_DATA_ERROR and loop again in the tasklet.
> 7. We hit STATE_DATA_ERROR but the transfer isn't done, so the tasklet
>    stops.
> 
> We never seem to get any additional DMA interrupts that cause
> EVENT_XFER_COMPLETE and restart the tasklet so we just hang.  That
> doesn't seem surprising given that we've stopped DMA.
> 
> We did put a print at the end of dw_mci_interrupt() to show the result
> of the "mci_readl(host, IDSTS)" and saw 0xa000 in the case of the
> above CRC error.
> 
> A proposed fix for this is to ignore (but still clear) the
> EVENT_XFER_COMPLETE in STATE_DATA_ERROR in the tasklet.
> 
> Reported-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 9834221..696b3bb 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1137,10 +1137,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  			goto unlock;
>  
>  		case STATE_DATA_ERROR:
> -			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
> -						&host->pending_events))
> -				break;
> -
> +			clear_bit(EVENT_XFER_COMPLETE, &host->pending_events);
>  			state = STATE_DATA_BUSY;
>  			break;
>  		}
> 


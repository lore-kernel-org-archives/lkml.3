Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaG0OPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 10:15:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28289 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaG0OPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 10:15:08 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-86-53d509690006
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Seungwon Jeon'" <tgih.jun@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Sonny Rao'" <sonnyrao@chromium.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'sunil joshi'" <joshi@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Yuvaraj Kumar C D'" <yuvaraj.cd@gmail.com>, chris@printf.net,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1400623670-2657-1-git-send-email-dianders@chromium.org>
 <001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
In-reply-to: <001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
Subject: RE: [PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get
 an error
Date: Sun, 27 Jul 2014 23:15:04 +0900
Message-id: <000c01cfa9a5$2979a650$7c6cf2f0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac90eBtNVnNipEghRGmCtddOh0fNNwAWjkTQDTSRdgA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t8zY91MzqvBBmtvcFpMuLyd0WL7641s
	FmeXHWSzeHXkB5PFjV9trBbfd31ht+hdcJXN4vKuOWwWR/73M1rMOL+PyeLJmZmMFutnvGax
	+HD/IrPF8bXhFg+PdrM68HvMbrjI4rFz1l12j0NX1jJ63Lm2h83jxquFTB59W1YxenzeJBfA
	HsVlk5Kak1mWWqRvl8CVcXwLd8FV5YqNf5eyNTCulepi5OSQEDCRaJq1iwnCFpO4cG89Wxcj
	F4eQwDJGidlH+plgik6tbGKHSExnlLi+9gszhPOHUeLGni2sIFVsAloSf9+8AUuICDQySvxZ
	fI8JxGEW2MgsMePcNqB+DqCWConnz91AGjgF7CS2L2pmAbGFBSIknu5uZgexWQRUJRbe/MsG
	YvMK2Ers69nJCmELSvyYfA+snlnAQOL9rD5WCFteYvOat8wg4yUE1CUe/dUFCYsIWEns+rmY
	HaJERGLfi3eMIOdICOzgkJiw4AUzxC4BiW+TD7FA9MpKbDrADPGxpMTBFTdYJjBKzEKyeRaS
	zbOQbJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCEJoncH4+0D1ocYk4HWT2SW
	Ek3OByaYvJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgLCt8+6pAn7H1kVtz93/xF0oq/4MsTylWJt1WXK5n8ETOrTP6GkOa7XPvm7u9vY4L7ln9
	yydjr+ZTx8tsnnmWp9tPip5dd0547oMW1QJvif/bze556+39eD9v7ZqQGIkHihtj9L47eTRo
	hFewptb8WrVK2lSIefrHPAm2Pe/2zf28O/HX0fynSizFGYmGWsxFxYkAy2mOQSYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jQd1MzqvBBv/vM1tMuLyd0WL7641s
	FmeXHWSzeHXkB5PFjV9trBbfd31ht+hdcJXN4vKuOWwWR/73M1rMOL+PyeLJmZmMFutnvGax
	+HD/IrPF8bXhFg+PdrM68HvMbrjI4rFz1l12j0NX1jJ63Lm2h83jxquFTB59W1YxenzeJBfA
	HtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLiS
	QlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP4Fu6Cq8oVG/8uZWtgXCvV
	xcjJISFgInFqZRM7hC0mceHeerYuRi4OIYHpjBLX135hhnD+MErc2LOFFaSKTUBL4u+bN2AJ
	EYFGRok/i+8xgTjMAhuZJWac2wY0iwOopULi+XM3kAZOATuJ7YuaWUBsYYEIiae7m8HWsQio
	Siy8+ZcNxOYVsJXY17OTFcIWlPgx+R5YPbOAgcT7WX2sELa8xOY1b5lBxksIqEs8+qsLEhYR
	sJLY9XMxO0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOD080x6B+OqBotDjAIcjEo8vAIsV4KFWBPLiitzDzFKcDArifAWvgUK8aYkVlal
	FuXHF5XmpBYfYjQFenQis5Rocj4wNeaVxBsam5gZWRqZWRiZmJsrifMebLUOFBJITyxJzU5N
	LUgtgulj4uCUamB0yTl9Sdr22MxJHwU2nNO/Nsd0Tt5MgeSN134a+4SkR4sbfa5aN3Xe7iP9
	wYkHb+9exDtn9+bErdyHJ8Sv6lillXDhcKscS660B4/Vwtk2H9Y6KN+z8o10alvKpPZd+/1p
	5ciFV9od5C+ZreNKyKnT/BavqiESIircoua4sTmzoizxcOQlqXYlluKMREMt5qLiRADEuzcY
	VQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris & Ulf,

I hope you find this patch for next.

Thanks,
Seungwon Jeon

On Wed, May 21, 2014, Seungwon Jeon wrote:
> On Wed, May 21, 2014, Doug Anderson wrote:
> > If we happened to get a data error at just the wrong time the dw_mmc
> > driver could get into a state where it would never complete its
> > request.  That would leave the caller just hanging there.
> >
> > We fix this two ways and both of the two fixes on their own appear to
> > fix the problems we've seen:
> >
> > 1. Fix a race in the tasklet where the interrupt setting the data
> >    error happens _just after_ we check for it, then we get a
> >    EVENT_XFER_COMPLETE.  We fix this by repeating a bit of code.
> > 2. Fix it so that if we detect that we've got an error in the "data
> >    busy" state and we're not going to do anything else we end the
> >    request and unblock anyone waiting.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> > Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
> 
> It will be applied after "mmc: dw_mmc: change to use recommended reset procedure"
> 
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
> 
> Thanks,
> Seungwon Jeon
> 
> > ---
> > Changes in v2:
> > - Removed TODO
> > - Set cmd to NULL before calling dw_mci_request_end()
> >
> >  drivers/mmc/host/dw_mmc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> >
> > diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> > index cced599..54ec8b0 100644
> > --- a/drivers/mmc/host/dw_mmc.c
> > +++ b/drivers/mmc/host/dw_mmc.c
> > @@ -1318,6 +1318,14 @@ static void dw_mci_tasklet_func(unsigned long priv)
> >  			/* fall through */
> >
> >  		case STATE_SENDING_DATA:
> > +			/*
> > +			 * We could get a data error and never a transfer
> > +			 * complete so we'd better check for it here.
> > +			 *
> > +			 * Note that we don't really care if we also got a
> > +			 * transfer complete; stopping the DMA and sending an
> > +			 * abort won't hurt.
> > +			 */
> >  			if (test_and_clear_bit(EVENT_DATA_ERROR,
> >  					       &host->pending_events)) {
> >  				dw_mci_stop_dma(host);
> > @@ -1331,7 +1339,29 @@ static void dw_mci_tasklet_func(unsigned long priv)
> >  				break;
> >
> >  			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
> > +
> > +			/*
> > +			 * Handle an EVENT_DATA_ERROR that might have shown up
> > +			 * before the transfer completed.  This might not have
> > +			 * been caught by the check above because the interrupt
> > +			 * could have gone off between the previous check and
> > +			 * the check for transfer complete.
> > +			 *
> > +			 * Technically this ought not be needed assuming we
> > +			 * get a DATA_COMPLETE eventually (we'll notice the
> > +			 * error and end the request), but it shouldn't hurt.
> > +			 *
> > +			 * This has the advantage of sending the stop command.
> > +			 */
> > +			if (test_and_clear_bit(EVENT_DATA_ERROR,
> > +					       &host->pending_events)) {
> > +				dw_mci_stop_dma(host);
> > +				send_stop_abort(host, data);
> > +				state = STATE_DATA_ERROR;
> > +				break;
> > +			}
> >  			prev_state = state = STATE_DATA_BUSY;
> > +
> >  			/* fall through */
> >
> >  		case STATE_DATA_BUSY:
> > @@ -1354,6 +1384,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
> >  				/* stop command for open-ended transfer*/
> >  				if (data->stop)
> >  					send_stop_abort(host, data);
> > +			} else {
> > +				/*
> > +				 * If we don't have a command complete now we'll
> > +				 * never get one since we just reset everything;
> > +				 * better end the request.
> > +				 *
> > +				 * If we do have a command complete we'll fall
> > +				 * through to the SENDING_STOP command and
> > +				 * everything will be peachy keen.
> > +				 */
> > +				if (!test_bit(EVENT_CMD_COMPLETE,
> > +					      &host->pending_events)) {
> > +					host->cmd = NULL;
> > +					dw_mci_request_end(host, mrq);
> > +					goto unlock;
> > +				}
> >  			}
> >
> >  			/*
> > --
> > 1.9.1.423.g4596e3a
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


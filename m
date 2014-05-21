Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaEUJIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:08:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27678 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEUJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:08:21 -0400
X-AuditID: cbfee68f-b7fef6d000003970-5c-537c6d03dc13
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
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
In-reply-to: <1400623670-2657-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get
 an error
Date: Wed, 21 May 2014 18:08:19 +0900
Message-id: <001601cf74d4$3547a410$9fd6ec30$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac90eBtNVnNipEghRGmCtddOh0fNNwAWjkTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+ZsS5zbk2wQcd8GYsJl7czWmx/vZHN
	4uyyg2wWr478YLK48auN1eL7ri/sFr0LrrJZXN41h83iyP9+RosZ5/cxWTw5M5PRYv2M1ywW
	x9eGWzw82s3qwOcxu+Eii8fOWXfZPQ5dWcvocefaHjaPG68WMnn0bVnF6PF5k1wAexSXTUpq
	TmZZapG+XQJXxv6ZbewFa+Ur/ra8Y2tg3CjexcjJISFgInFpcy8bhC0mceHeeiCbi0NIYBmj
	xPLli9hgihbubmCCSExnlNj1YiJU1R9GiWn9CxhBqtgEtCT+vnnD3MXIwSEiEC6x96YKSA2z
	wEZmiRnntrGD1AgJuEhc/rSTDaSGU8BV4sGDKJCwsECExNPdzWAlLAKqEqvvTWQFKeEVsJW4
	c4sXJMwrICjxY/I9FhCbWcBA4v2sPlYIW15i85q3YFslBNQlHv3VBQmLCBhJTNvUDVUuIrHv
	xTtGkGskBLZwSFzYuxdqlYDEt8mHWCB6ZSU2HWCGeFdS4uCKGywTGCVmIdk8C8nmWUg2z0Ky
	YgEjyypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkJTQv4Px7gHrQ4zJQOsnMkuJJucDU0pe
	SbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBk3LDq
	zq8bX4yXyl/Y79hky/X4/rWTWuVbqj6dsrEL2V5y3ueEtf03zyMnrufFPUsva+bfunD68ezd
	H4MqXZ+yB/zu+Won1n/z1KkNc5aFyR4KPlMdsJBp09OyFZrbDRtSYpl5Sg7xr7BrOOvxbMJC
	hkLlVOv8Yxk/F5/fv8rixFzT3xnz7y7zUmIpzkg01GIuKk4EAGYRxi4fAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jQV3m3Jpgg47zYhYTLm9ntNj+eiOb
	xdllB9ksXh35wWRx41cbq8X3XV/YLXoXXGWzuLxrDpvFkf/9jBYzzu9jsnhyZiajxfoZr1ks
	jq8Nt3h4tJvVgc9jdsNFFo+ds+6yexy6spbR4861PWweN14tZPLo27KK0ePzJrkA9qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJuVFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBn7Z7axF6yVr/jb8o6tgXGjeBcjJ4eE
	gInEwt0NTBC2mMSFe+vZuhi5OIQEpjNK7HoxEcr5wygxrX8BI0gVm4CWxN83b5i7GDk4RATC
	JfbeVAGpYRbYyCwx49w2dpAaIQEXicufdrKB1HAKuEo8eBAFEhYWiJB4ursZrIRFQFVi9b2J
	rCAlvAK2Endu8YKEeQUEJX5MvscCYjMLGEi8n9XHCmHLS2xe8xZsq4SAusSjv7ogYREBI4lp
	m7qhykUk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIEJ5xn0jsYVzVYHGIU4GBU4uFdUFQdLMSaWFZcmXuIUYKDWUmE90pETbAQb0piZVVqUX58
	UWlOavEhxmSgPycyS4km5wOTYV5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1ML
	UotgtjBxcEo1MC6/e+DgwQ2P3m9RXi0R/ELBMfcnz9ZXr9sOxrDFZK5bd+W/O+vdRE6vCpbI
	nSJ5LNMUT1c97zZtPJz+Lbzriv8UoXW/+FRCPAJKDVxfPytTb+U0EGzao5aaGmHeu1l5Su+B
	DUY76sreLWnpbo+48ea0s+Q3lXUqKYp2Xb7ZV/NcdkvU/0yeo8RSnJFoqMVcVJwIAE89grh8	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014, Doug Anderson wrote:
> If we happened to get a data error at just the wrong time the dw_mmc
> driver could get into a state where it would never complete its
> request.  That would leave the caller just hanging there.
> 
> We fix this two ways and both of the two fixes on their own appear to
> fix the problems we've seen:
> 
> 1. Fix a race in the tasklet where the interrupt setting the data
>    error happens _just after_ we check for it, then we get a
>    EVENT_XFER_COMPLETE.  We fix this by repeating a bit of code.
> 2. Fix it so that if we detect that we've got an error in the "data
>    busy" state and we're not going to do anything else we end the
>    request and unblock anyone waiting.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>

It will be applied after "mmc: dw_mmc: change to use recommended reset procedure"

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

> ---
> Changes in v2:
> - Removed TODO
> - Set cmd to NULL before calling dw_mci_request_end()
> 
>  drivers/mmc/host/dw_mmc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index cced599..54ec8b0 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1318,6 +1318,14 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  			/* fall through */
> 
>  		case STATE_SENDING_DATA:
> +			/*
> +			 * We could get a data error and never a transfer
> +			 * complete so we'd better check for it here.
> +			 *
> +			 * Note that we don't really care if we also got a
> +			 * transfer complete; stopping the DMA and sending an
> +			 * abort won't hurt.
> +			 */
>  			if (test_and_clear_bit(EVENT_DATA_ERROR,
>  					       &host->pending_events)) {
>  				dw_mci_stop_dma(host);
> @@ -1331,7 +1339,29 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  				break;
> 
>  			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
> +
> +			/*
> +			 * Handle an EVENT_DATA_ERROR that might have shown up
> +			 * before the transfer completed.  This might not have
> +			 * been caught by the check above because the interrupt
> +			 * could have gone off between the previous check and
> +			 * the check for transfer complete.
> +			 *
> +			 * Technically this ought not be needed assuming we
> +			 * get a DATA_COMPLETE eventually (we'll notice the
> +			 * error and end the request), but it shouldn't hurt.
> +			 *
> +			 * This has the advantage of sending the stop command.
> +			 */
> +			if (test_and_clear_bit(EVENT_DATA_ERROR,
> +					       &host->pending_events)) {
> +				dw_mci_stop_dma(host);
> +				send_stop_abort(host, data);
> +				state = STATE_DATA_ERROR;
> +				break;
> +			}
>  			prev_state = state = STATE_DATA_BUSY;
> +
>  			/* fall through */
> 
>  		case STATE_DATA_BUSY:
> @@ -1354,6 +1384,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  				/* stop command for open-ended transfer*/
>  				if (data->stop)
>  					send_stop_abort(host, data);
> +			} else {
> +				/*
> +				 * If we don't have a command complete now we'll
> +				 * never get one since we just reset everything;
> +				 * better end the request.
> +				 *
> +				 * If we do have a command complete we'll fall
> +				 * through to the SENDING_STOP command and
> +				 * everything will be peachy keen.
> +				 */
> +				if (!test_bit(EVENT_CMD_COMPLETE,
> +					      &host->pending_events)) {
> +					host->cmd = NULL;
> +					dw_mci_request_end(host, mrq);
> +					goto unlock;
> +				}
>  			}
> 
>  			/*
> --
> 1.9.1.423.g4596e3a
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


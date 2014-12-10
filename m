Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaLJECZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:02:25 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47715 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaLJECX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:02:23 -0500
Date: Tue, 9 Dec 2014 20:02:19 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 10/12] input: cyapa: add gen5 trackpad device read
 baseline function support
Message-ID: <20141210040219.GB4173@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
 <1418116304-11392-11-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418116304-11392-11-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Tue, Dec 09, 2014 at 05:11:42PM +0800, Dudley Du wrote:
> Add read baseline function supported for gen5 trackpad device,
> it can be used through sysfs baseline interface.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
[...]
>  	return 0;
>  }
>  
> +static int cyapa_gen5_resume_scanning(struct cyapa *cyapa)
> +{
> +	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x04 };
> +	u8 resp_data[6];
> +	int resp_len;
> +	int error;
> +
> +	/* Try to dump all bufferred data before doing command. */
                       ^^^^^^^^^
					   buffered

And there are three more below.

> +	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
> +
> +	resp_len = 6;
> +	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
> +			cmd, 7,
> +			resp_data, &resp_len,
> +			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
> +	if (error || !VALID_CMD_RESP_HEADER(resp_data, 0x04))
> +		return -EINVAL;
> +
> +	/* Try to dump all bufferred data when resuming scanning. */
> +	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
> +
> +	return 0;
> +}
> +
> +static int cyapa_gen5_suspend_scanning(struct cyapa *cyapa)
> +{
> +	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x03 };
> +	u8 resp_data[6];
> +	int resp_len;
> +	int error;
> +
> +	/* Try to dump all bufferred data before doing command. */
> +	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
> +
> +	resp_len = 6;
> +	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
> +			cmd, 7,
> +			resp_data, &resp_len,
> +			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
> +	if (error || !VALID_CMD_RESP_HEADER(resp_data, 0x03))
> +		return -EINVAL;
> +
> +	/* Try to dump all bufferred data when suspending scanning. */
> +	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
> +
> +	return 0;
> +}
> +
[...]

-- 
- Jeremiah Mahler

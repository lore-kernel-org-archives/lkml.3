Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbbASA0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:26:40 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37741 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbASA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:26:39 -0500
Date: Sun, 18 Jan 2015 16:26:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: jmmahler@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 09/12] input: cyapa: add gen5 trackpad device
 firmware update function support
Message-ID: <20150119002634.GA23278@dtor-glaptop>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-10-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421390055-32760-10-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:34:12PM +0800, Dudley Du wrote:
> +	/* APP_INTEGRITY row is always the last row block,
> +	 * and the row id must be 0x01ff */
> +	row_num = get_unaligned_be16(
> +			&image->records[flash_records_count - 1].row_number);
> +	if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
> +			row_num != 0x01ff) {

By the way, shouldn't this be "or" and not "and"?

> +		dev_err(dev, "%s: invalid app_integrity data.\n", __func__);
> +		return -EINVAL;
> +	}

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaHRMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:25:59 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:41263 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaHRMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:25:56 -0400
Message-ID: <53F1F0D1.6070102@suse.cz>
Date: Mon, 18 Aug 2014 14:25:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, gregkh@linuxfoundation.org
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
References: <1407242145-3132-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1407242145-3132-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014, 02:35 PM, Sudip Mukherjee wrote:
> printk replaced with corresponding dev_err, dev_alert, dev_notice and pr_info.
> pr_info has been used instead of dev_info as there is a check for port->dev being NULL or not.
> fixed two broken user-visible strings used by the corresponding printk
> 
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
> 
> For my previous patch ,Jiri Slaby told to investigate further as I have used uport->dev and there was a check for whether it is NULL. 
> For this patch instead of uport->dev , i have used tty_dev as that one gave a better desciption of the device than uport->dev.

Hi, that will not work either, as there is put_device(tty_dev) before
you use tty_dev.

-- 
js
suse labs

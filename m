Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CHG5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:57:23 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55434 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3CHG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:57:20 -0500
MIME-Version: 1.0
In-Reply-To: <1362714214-32405-2-git-send-email-bleung@chromium.org>
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
	<1362714214-32405-1-git-send-email-bleung@chromium.org>
	<1362714214-32405-2-git-send-email-bleung@chromium.org>
Date: Thu, 7 Mar 2013 22:57:19 -0800
X-Google-Sender-Auth: uNS4GzfjHDo6aT23jBLk4woHdeY
Message-ID: <CANLzEks+1DS8qUwbyVQU6WdyT2pKYKWYJGNOjyExR8dGG0AHng@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Input: atmel_mxt_ts - Support for touchpad variant
From: Benson Leung <bleung@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>, wfp5p@virginia.edu,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>, David Miller <davem@davemloft.net>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 7:43 PM, Benson Leung <bleung@chromium.org> wrote:
> +static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
> +{
> +       struct device *dev = &data->client->dev;
Oops. I missed a warning: unused variable 'dev' here.

> +       struct input_dev *input = data->input_dev;
> +       bool button;
> +       int i;
> +
> +       /* Active-low switch */
> +       for (i = 0; i < MXT_NUM_GPIO; i++) {
> +               if (data->pdata->key_map[i] == KEY_RESERVED)
> +                       continue;
> +               button = !(message->message[0] & MXT_GPIO0_MASK << i);
> +               input_report_key(input, data->pdata->key_map[i], button);
> +       }
> +}
> +




--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

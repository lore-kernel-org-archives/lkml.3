Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaE1VPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:15:40 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58515 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaE1VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com> <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Wed, 28 May 2014 16:15:16 -0500
Message-ID: <CA+BWVUQEsprV1jEzD9D0hidR0jvYeSRVGT=ESzstR4apa+nV1A@mail.gmail.com>
Subject: Re: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for
 True/Magnetic North HID usages
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void sensor_hub_fill_attr_info(
> +               struct hid_sensor_hub_attribute_info *info,
> +               s32 index, s32 report_id, struct hid_field *field)
> +{
> +       info->index = index;
> +       info->report_id = report_id;
> +       info->units = field->unit;
> +       info->unit_expo = field->unit_exponent;
> +       info->size = (field->report_size * field->report_count)/8;
> +       info->logical_minimum = field->logical_minimum;
> +       info->logical_maximum = field->logical_maximum;
>  }

I copied this function from hid/hid-sensor-hub.c as it is marked
static in that file. I use it to fill attributes as I find them.
Should I create an another patch to make it non-static?

> +       list_for_each_entry(report, &report_enum->report_list, list) {
> +               for (i = 0; i < report->maxfield; ++i) {
> +                       field = report->field[i];
> +
> +                       for (j = 0; j < field->maxusage; j++) {
> +                               usage = &(field->usage[j]);
> +

This is how I mange to find all possible hid reports in the parse
reports function. I noticed that in the other function that was used,
sensor_hub_input_get_attribute_info(),  it only uses field->usage[0].
Is there a reason for this and should I change my current
implementation?

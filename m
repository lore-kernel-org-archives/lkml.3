Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBKDNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:13:41 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:41525 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaBKDNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140210173811.04ba5964@endymion.delvare>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
Date: Tue, 11 Feb 2014 03:13:37 +0000
X-Google-Sender-Auth: E-bre4roc-tvWchv09M1VGgej28
Message-ID: <CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
> Additionally, dashes are explicitly forbidden in hwmon
> device names.

Also, where is that documented?

I do not think you can make such a decision, and you will realize that
once you begin to think a bit out of the box and look around. See how
other children are managed for MFD devices. "driver-subsystem" is a
pretty common a schema. I do not really see any point in forbidding
dashes currently. Please do elaborate about the reasons, and the fact
that why it is undocuemented.

Also, I currently do not understand what you are suggesting: just
leave this technically unreasonable situation as is for compatibility
reasons? There is no better support in place for appending further
alternative names?

In any case, at the very least, I hope the lesson is learnt for the
future from this past mistake. If a chip is MFD'ish, a subdevice
driver should not ever be added with such an id.

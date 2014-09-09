Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaIIFJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:09:16 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60138 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIIFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <54003b5a.ac26460a.73fc.ffffe939@mx.google.com>
References: <54003b5a.ac26460a.73fc.ffffe939@mx.google.com>
Date: Tue, 9 Sep 2014 13:09:13 +0800
Message-ID: <CANLzEku4fxNbNQ6fufpAvQ2YWnZ1gpZZugxZm2xbguTAm+_q-g@mail.gmail.com>
Subject: Re: [PATCH V5 14/14] input: cyapa: add function to monitor LID close
 event to off trackpad device
From: Benson Leung <bleung@google.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, patrik@google.com,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,


On Fri, Aug 29, 2014 at 4:35 PM, Dudley Du <dudley.dulixin@gmail.com> wrote:
> Add the function to monitor lid close event to suspend and resume
> trackpad device.
> Because system suspend takes some time to trigger from user space,
> and in that time, the lid panel of the laptop may couple with the
> active trackpad. This may generate stray input events, which may
> in turn cancel the suspend if the drivers use pm_wakup_event(), and
> those input events may trigger something unwanted in the UI.
> So this patch adds the function to do off the trackpad device quickly.
> When the lid is closed, as soon as possible, the trakcpad device must
> be off. And furthermore, the policy on lid close is not always to
> enter suspend (lid closed with external display), and at this time,
> the trackpad device must be disabled as well as again to avoid the
> risk of generating stray events.
> TEST=test on Chromebooks.
>
> Signed-off-by: Dudley Du <dudl@cyrpess.com>

So, I think for the chromeos-kernel, we are moving away from this hack
lid filter solution. Very soon we'll remove this in favor of something
else, so my suggestion would be to drop this from your patch series.



-- 
Benson Leung
Software Engineer, Chrome OS
Google Inc.
bleung@google.com

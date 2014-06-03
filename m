Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaFCGlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:41:04 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44036 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaFCGlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140602125055.GE31751@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
	<CAD7vxxKT+Wq2ArH9iYLm2OUeBSqKvzORKZ1NnoyPcdcDH6wOKw@mail.gmail.com>
	<20140602125055.GE31751@sirena.org.uk>
Date: Mon, 2 Jun 2014 23:41:01 -0700
Message-ID: <CAD7vxxKgauFdEavebiZ3u7pXhjJu9QqwW0nMuLbEr7+JJWssfA@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
From: Tim Kryger <tim.kryger@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 5:50 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jun 02, 2014 at 12:12:20AM -0700, Tim Kryger wrote:
>
>> The probe method of this driver, on the other hand, performs several
>> allocations and the error messages you intend to remove conveniently
>> pinpoint which one failed.  While the offsets in the trace could be
>> used to derive the same information, I am skeptical that is enough to
>> justify removing the messages.
>
> On the other hand how likely is anyone to care which particular
> allocation triggered the OOM?

I suppose you would only care if a failure was due to something unique
about a specific allocation.  For example, if someone made a foolish
change to a structure that resulted in a request for substantially
more memory, the messages would lead directly to the problem.

The real question is whether this change improves the driver.  To me,
it seems like a draw.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaKEJHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:07:18 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22884 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaKEJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:07:04 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-15-5459e8a45fbe
Message-id: <1415178403.15850.17.camel@AMDC1943>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Wed, 05 Nov 2014 10:06:43 +0100
In-reply-to: <20141104194729.GV3815@sirena.org.uk>
References: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl>
 <20141103120919.GE3815@sirena.org.uk> <545795D8.1040600@topic.nl>
 <20141103151058.GP3815@sirena.org.uk> <5457BD85.2070901@topic.nl>
 <54589472.8030305@topic.nl> <20141104113417.GG3815@sirena.org.uk>
 <5458D636.3000401@topic.nl> <20141104194729.GV3815@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xy7pLXkSGGJx/rmgx9eETNoujvwss
	vl3pYLK4vGsOm0XXzi1sDqwef59fZ/HYOesuu8emVZ1sHi+2XWPz+LxJLoA1issmJTUnsyy1
	SN8ugSvjStcypoLdHBWvDqxmbmB8xNbFyMkhIWAisfzcDnYIW0ziwr31QHEuDiGBpYwSWzdu
	gXI+M0rsODCLGaSKV8BA4uPtxUxdjBwcwgI2Eg++6YKE2QSMJTYvXwI2VERAWeLq970sIL3M
	AvMZJU5MWM8CkmARUJVY/XATK4jNKWAk8eX7GagFs5glzp9ZDZZgFlCXmDRvETPIAgmgSY39
	bhB7BSV+TL7HAlEiL7F5zVvmCYwCs5B0zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnp
	esn5uZsYIQH9dQfj0mNWhxgFOBiVeHg9miJDhFgTy4orcw8xSnAwK4nwcl4CCvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamD0uJ6v0hBovJ13/qHZDeKN2xr9uq7/rZwpmasvX7EzSeutypL980pY
	CjUNP0r73Flq3Kf2eV61jNtbuVczPddMfO/sspgpMGLNN74+5oAjj/mC19y69Ue069AW6zu/
	t+akWs07dYe93kX++09+piO/i7X4tn6XXeH/8J6q9+vLwvn53PZVBtVKLMUZiYZazEXFiQCw
	zjf+RgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 19:47 +0000, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 02:35:50PM +0100, Mike Looijmans wrote:
> 
> > I still need help with one thing that isn't clear to me though. The DT is
> > parsed when calling regulator_register. But then how do I fetch my "private"
> > settings in there BEFORE the regulator gets enabled? The feedback resistors
> > and regulator mode must be set to the correct board before the output is
> > enabled, otherwise it may damage the chip and its periferals.
> 
> Add a callback for this.  Javier and/or Krzysztof were looking at this
> for some other stuff, though I think they were intending to add core
> functionality for their specific feature.

I needed a callback and added such. The callback was called on each DT
node parsed. However I dropped that idea because it turned our to be
unsuitable to my case.

I needed to feed regulator_config.ena_gpio with data parsed from such
callback. But the callback called from inside the regulator_register()
has the regulator_config const.

Best regards,
Krzysztof


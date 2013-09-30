Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3I3OVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:21:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59848 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752775Ab3I3OVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:21:40 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] powerpc/8xx: tqm8xx: fix incorrect placement of __initdata tag
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 30 Sep 2013 15:20:29 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B736B@saturn3.aculab.com>
In-Reply-To: <1589399.KSlGuZSdd2@amdc1032>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] powerpc/8xx: tqm8xx: fix incorrect placement of __initdata tag
Thread-Index: Ac694EuOmQU5B5miQve0tCxICZl73QABnpgA
References: <1589399.KSlGuZSdd2@amdc1032>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Vitaly Bordug" <vitb@kernel.crashing.org>
Cc: "Marcelo Tosatti" <marcelo@kvack.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
...
> -static struct __initdata cpm_pin tqm8xx_pins[] = {
> +static struct cpm_pin tqm8xx_pins[] __initdata = {

As far as gcc is concerned it can go almost anywhere before the '=',
even before the 'static'.
Splitting 'struct cpm_pin' does seem an odd choice.

The Linux coding standards might suggest a location.
I'd have thought that either before or after the 'static' would be best
(ie as a storage class qualifier).

	David




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3FMMAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:00:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16669 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3FMMAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:00:41 -0400
X-AuditID: cbfee68f-b7f436d000000f81-2a-51b9b467cbef
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Simon Glass'" <sjg@chromium.org>,
        "'Luigi Semenzato'" <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-kernel@vger.kernel.org
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
In-reply-to: <1371058399-31933-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 1/3] pinctrl: exynos: Add spinlocks to irq_mask and
 irq_unmask
Date: Thu, 13 Jun 2013 21:00:39 +0900
Message-id: <150701ce682d$9f622730$de267590$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5nkvX5x9jR5tt0S+C6mSZc1SgCHAAmo7JA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zA930LTsDDd49s7A4u+wgm8WzO1eY
	LY7+W8hoMeXPciaLy7vmsFmcuv6ZzeLz1S8sFt+2bGO0WLXrD6MDp8fshossHjtn3WX3uHNt
	D5vHlRNNrB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV8evmTMaCxcwV55b/Ym1gvMDUxcjJ
	ISFgItH7o4kdwhaTuHBvPVsXIxeHkMAyRol9j06ywBR9v/CYCSKxiFGi6eM9dgjnL6PE6anv
	wNrZBDQkDr9/BmaLCERKTDhwjhmkiFngDaPE8ufvWEESQgKuEnv+zGEEsTkF3CQmPf4ItkJY
	IETi+vn/YM0sAqoSrTcug9XzCthKPGu9xw5hC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW+BlnEA
	naou8eivLsQNRhK7791nhCgRkdj34h0jyD0SAq0cEmtf7GWG2CUg8W3yIRaIXlmJTQeYIT6W
	lDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyS+
	+3cw3j1gfYgxGWj9RGYp0eR8YHrIK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAPjxIhzrfbrymW8MncW3EpI5Iv6kNCuUHqiLvfM4QVx7JtUesyl
	9Pv2dr/QO6X9/phO6aptF3c8jGg1vXhbI/qanfimguZl3/3Uz1dP+9baufPR7hYz7rqbnj98
	A87w/JvvIPX23qSXD58mX5HY21i5b4NtXsuk9vrwVzG9R4on3tCZJRKU3qCvxFKckWioxVxU
	nAgAtKusEAUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jAd30LTsDDY7eNbY4u+wgm8WzO1eY
	LY7+W8hoMeXPciaLy7vmsFmcuv6ZzeLz1S8sFt+2bGO0WLXrD6MDp8fshossHjtn3WX3uHNt
	D5vHlRNNrB59W1YxenzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkDdJaSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCO
	MePXzZmMBYuZK84t/8XawHiBqYuRk0NCwETi+4XHULaYxIV769m6GLk4hAQWMUo0fbzHDuH8
	ZZQ4PfUdO0gVm4CGxOH3z8BsEYFIiQkHzjGDFDELvGGUWP78HStIQkjAVWLPnzmMIDangJvE
	pMcfWUBsYYEQievn/4M1swioSrTeuAxWzytgK/Gs9R47hC0o8WPyPbB6ZgEtifU7jzNB2PIS
	m9e8BVrGAXSqusSjv7oQNxhJ7L53nxGiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNo
	akFyQXFSeq6RXnFibnFpXrpecn7uJkZw8ngmvYNxVYPFIUYBDkYlHt6XF3YECrEmlhVX5h5i
	lOBgVhLhvTl1Z6AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wMTW15JvKGxiZmRpZGZhZGJ
	uTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MAZp/OhJFZaYfS83YdIXzjNsIgsPZm8/
	P9ul5+yJfQU2va5neU9pmm6XeVtZnhqmlv1ba9qk/Vm2t/W+u3nfdpGTSWdW/tJxa7tjhuqR
	80o37m2N5LXcOuEeV2bxtVN7Dtp0l8l/ZXW73fco8tYeFfZN258eF3TymchaUBAQtOCDqTCj
	sMmMHCWW4oxEQy3mouJEAOBFCfpiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> The patch:
>   1984695 pinctrl: samsung: Protect bank registers with a spinlock
> 
> ...added spinlocks to protect many accesses.  However, the irq_mask
> and irq_unmask functions still do an unprotected read/modify/write.
> Add the spinlock there.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Thanks :-)

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

- Kukjin


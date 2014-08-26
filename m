Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbaHZElq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:41:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18876 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaHZEln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:41:43 -0400
X-AuditID: cbfee691-f79546d0000011a1-c1-53fc1005ac39
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, jonghwa3.lee@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/2] power: charger-manager: Fix bug and resolve mismatch
 issue
Date: Tue, 26 Aug 2014 13:41:37 +0900
Message-id: <1409028099-6081-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkUJdV4E+wwfw//BbXvzxntZj05D2z
	xcSVk5ktOs8+Yba4vGsOm8Xn3iOMFrcbV7BZnN5d4sDhsXPWXXaPzSu0PDat6mTz6NuyitHj
	8ya5ANYoLpuU1JzMstQifbsEroxzkx6wFaxmrVhx9x9TA+MWli5GDg4JAROJrm1+XYycQKaY
	xIV769m6GLk4hASWMkr0bOxkg0iYSLQ++cAKkVjEKPHjyxRGCKeJSaLp9iewKjYBLYn9L26A
	2SICthI9Tw8ygxQxC8xglLjzpZcVJCEsECyxbPUKJhCbRUBV4sLVP+wgNq+Ai8THQw1Q6+Qk
	Pux5xA7SLCHQzi4xadkPFogGAYlvkw9B3S0rsekAM0S9pMTBFTdYJjAKLmBkWMUomlqQXFCc
	lF5kqlecmFtcmpeul5yfu4kRGL6n/z2buIPx/gHrQ4wCHIxKPLw34n8HC7EmlhVX5h5iNAXa
	MJFZSjQ5HxgleSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MK6dMKNx66xNH//d3fLucY+BeCwD/znjCYsaj8zoPrxjcqP40UWPFtQz1TfZMF7/vCz/
	NUc201znWtlru7mif+68K8F9Y/dErvRXd/59mbVOqO9JbwtPX1q91k5GfQeJcIOZrEc+Kcj+
	m2PesX35pc2tPZ9uzHkgHK2n+FWJ+XdoLd8SFrnboSxKLMUZiYZazEXFiQBlfLpwWgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV1WgT/BBp+bOC2uf3nOajHpyXtm
	i4krJzNbdJ59wmxxedccNovPvUcYLW43rmCzOL27xIHDY+esu+wem1doeWxa1cnm0bdlFaPH
	501yAaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzzk16wFawmrVixd1/
	TA2MW1i6GDk5JARMJFqffGCFsMUkLtxbz9bFyMUhJLCIUeLHlymMEE4Tk0TT7U9sIFVsAloS
	+1/cALNFBGwlep4eZAYpYhaYwShx50sv2ChhgWCJZatXMIHYLAKqEheu/mEHsXkFXCQ+Hmpg
	g1gnJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8cz6R2MqxosDjEK
	cDAq8fDeiP8dLMSaWFZcmXuIUYKDWUmEl+EhUIg3JbGyKrUoP76oNCe1+BCjKdD2icxSosn5
	wNjNK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAOM9s/tLdJvGS
	1nMmRAtGv/3yZ3uU0aMfJpaq3YuXfbb+dKTdrVagp/Ho9C1TPdfM+rplt2zWj2zLraX3uF55
	p9lf/b3n9M47W32Y/53s5EuMC2FjP3j6UF99rnjy2dU/jsXOY6qP3LeLzUPc5407+0Ybfv2X
	rvoXuQNsTx3I/bX2zMZvX5ezMSmxFGckGmoxFxUnAgBkX81DpQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix bug about checking wrong return type of of_cm_parse_desc()
and check the charging state after completed initialization of charger-manager
because existing charger-manger has the mismatch issue between real state of
cable connection and the charging state of charger-manager until first polling
time of charger-manager.

Changes from v1:
- This patchset includes new patch2.

Chanwoo Choi (2):
  power: charger-manager: Fix checking of wrong return type
  power: charger-manager: Check charging state right after completed initialization

 drivers/power/charger-manager.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
a.8.0


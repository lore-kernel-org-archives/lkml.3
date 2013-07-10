Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3GJOyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:54:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56561 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:54:38 -0400
X-AuditID: cbfee68f-b7f436d000000f81-19-51dd75ad0969
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Markos Chandras'" <markos.chandras@imgtec.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373400280-7408-1-git-send-email-dianders@chromium.org>
In-reply-to: <1373400280-7408-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: Handle DW_MCI_QUIRK_IDMAC_DTO properly
Date: Wed, 10 Jul 2013 23:54:36 +0900
Message-id: <002901ce7d7d$65223e10$2f66ba30$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5835IJCAuYGboGSyaFF1kMicMZbgALNpCg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zA921pXcDDd785LN4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2jx+fZ2VotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvo0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBkr//QxFhxmrvi9
	jb+B8SNTFyMnh4SAicSZoysYIWwxiQv31rN1MXJxCAksY5TYemEHG0zR9C0H2CES0xkl/r9d
	DVX1h1HiwqtLYFVsAloSf9+8YQaxRQS8JF7sfgBmMwt8ZJI4ulkExBYScJFY+uItWJxTwFVi
	0+JnQL0cHMICHhJnnhWBhFkEVCU29LxiAbF5BWwlpsw9wgRhC0r8mHyPBaScWUBdYsqUXIjp
	8hKb14BM5AC6U13i0V9diAOMJJbu7GGDKBGR2PfiHSPIxRICEzkkdu2ewAaxSkDi2+RDLBC9
	shKbDjBDvCspcXDFDZYJjBKzkCyehbB4FpLFs5BsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9d
	Lzk/dxMjJNL7dzDePWB9iDEZaPtEZinR5HxgosgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Ns0+Xc4dOvt3fHvWjZ/2Lt3tjVDt/TptzJ8fFv
	FTvDsLjfz9Fmicw6sy0rLSuvXlFuPTn7dFHHC6GFxx9YJyf7T1ggkX1labL30d/z9v9tuvdC
	wmTZHvVZ+kr9Ry0Mox+ZNfwsn2jL51fipTElpqP9yHqtpPjVzrarLlj89dnuxWVezr3kR78S
	S3FGoqEWc1FxIgC065NWCgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQd01pXcDDQ72qlg8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7T4fHs7q8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX06NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGEdYwZK//0MRYcZq74vY2/gfEjUxcjJ4eEgInE9C0H2CFsMYkL99azdTFycQgJ
	TGeU+P92NZTzh1HiwqtLbCBVbAJaEn/fvGEGsUUEvCRe7H4AZjMLfGSSOLpZBMQWEnCRWPri
	LVicU8BVYtPiZ0C9HBzCAh4SZ54VgYRZBFQlNvS8YgGxeQVsJabMPcIEYQtK/Jh8jwWknFlA
	XWLKlFyI6fISm9eATOQAulNd4tFfXYgDjCSW7uxhgygRkdj34h3jBEahWUgGzUIYNAvJoFlI
	OhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4jz6R2MK5ssDjEKMDBqMTD2xB/N1CI
	NbGsuDL3EKMEB7OSCK+6FVCINyWxsiq1KD++qDQntfgQYzLQmxOZpUST84EpLq8k3tDYxMzI
	0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGIue/uJdaLLhZVDbhY7/m98I
	B5vPV9GqmznXr3u66bQ7+jMfZbg2Sr75W54Y6mr9WF9H861OaP3adWZHF+zLj5ukOj+37XX3
	Qa0bpp8EQuSO3An7KmZ/Qvrz8rYP4Utv31i2sX76xA1vVzwPO6WbsbKubPreHdmKNdznalev
	+R+8YntCmeI8zVQlluKMREMt5qLiRAABwT7dZwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 10, 2013, Doug Anderson wrote:
> In (1fb5f68 mmc: dw_mmc: Don't loop when handling an interrupt), the
> code for handling DW_MCI_QUIRK_IDMAC_DTO became dead code.  Move it to
> where it ought to live.
> 
> Found by code inspection and compile-tested only--I don't know of any
> boards that need DW_MCI_QUIRK_IDMAC_DTO.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>


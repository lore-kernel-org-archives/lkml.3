Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaIKIAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:00:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36029 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaIKIAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:00:36 -0400
Message-ID: <1410422429.2857.16.camel@collabora.co.uk>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Date: Thu, 11 Sep 2014 10:00:29 +0200
In-Reply-To: <20140910092832.GM30307@lee--X1>
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
	 <540ED495.20609@collabora.co.uk> <20140910092832.GM30307@lee--X1>
Organization: Collabora Ltd.
Content-Type: multipart/signed; micalg="sha-1"; protocol="application/x-pkcs7-signature";
	boundary="=-R9N8fwdhAHJ/3xxDAwlh"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R9N8fwdhAHJ/3xxDAwlh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Lee,

On Wed, 2014-09-10 at 10:28 +0100, Lee Jones wrote:
> On Tue, 09 Sep 2014, Javier Martinez Canillas wrote:
>=20
> > [adding Lee Jones to cc list since I'm referring on a series he posted]
> >=20
> > Hello Sjoerd,
> >=20
> > On 09/09/2014 09:52 AM, Sjoerd Simons wrote:
> > > For i2c devices in OF the modalias exposed to userspace is i2c:<node
> > > type>, for the Maxtouch driver this is i2c:maxtouch.
> > >=20
> > > Add maxtouch to the i2c id table such that userspace can correctly
> > > load the module for the device and drop the OF table as it's not
> > > needed for i2c devices.
> > >=20
> > > Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> > > ---
> > >  drivers/input/touchscreen/atmel_mxt_ts.c | 8 +-------
> > >  1 file changed, 1 insertion(+), 7 deletions(-)
> > >=20
> > > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input=
/touchscreen/atmel_mxt_ts.c
> > > index db178ed..57ff26d 100644
> > > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > @@ -2267,16 +2267,11 @@ static int mxt_resume(struct device *dev)
> > > =20
> > >  static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
> > > =20
> > > -static const struct of_device_id mxt_of_match[] =3D {
> > > -	{ .compatible =3D "atmel,maxtouch", },
> > > -	{},
> > > -};
> > > -MODULE_DEVICE_TABLE(of, mxt_of_match);
> > > -
> > >  static const struct i2c_device_id mxt_id[] =3D {
> > >  	{ "qt602240_ts", 0 },
> > >  	{ "atmel_mxt_ts", 0 },
> > >  	{ "atmel_mxt_tp", 0 },
> > > +	{ "maxtouch", 0 },
> > >  	{ "mXT224", 0 },
> > >  	{ }
> > >  };
> > > @@ -2286,7 +2281,6 @@ static struct i2c_driver mxt_driver =3D {
> > >  	.driver =3D {
> > >  		.name	=3D "atmel_mxt_ts",
> > >  		.owner	=3D THIS_MODULE,
> > > -		.of_match_table =3D of_match_ptr(mxt_of_match),
> > >  		.pm	=3D &mxt_pm_ops,
> > >  	},
> > >  	.probe		=3D mxt_probe,
> > >=20
> >=20
> > I see that Lee is working to allow the I2C subsystem to not need an I2C=
 ID
> > table to match [0]. I'll let Lee to comment what the future plans are a=
nd if
> > his series are going to solve your issue since I'm not that familiar wi=
th the
> > I2C core.
>=20
> It's wrong to expect DT to probe these devices without a compatible
> string.  It does so at the moment, but this is a bi-product and not
> the correct method.

Ok, which means removing the mxt_of_match table in this patch is wrong..
I'll fix that for for a V2.

However that makes adding the "maxtouch" string to the i2c device table
somewhat cumbersome as it only gets added in this case to ensure
module-autoloading can happen as the modalias presented to userspace is
going still going to be i2c:maxtouch.

Tbh, the bigger problem this is pointing out is that for I2C devices
with only an OF compability tring module auto-loading is broken...

--=20
Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Collabora Ltd.

--=-R9N8fwdhAHJ/3xxDAwlh
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUzDCCBsIw
ggWqoAMCAQICEAoE3yF0XU0rjOozcgUAUOkwDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UEBhMCVVMx
FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UE
AxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTA2MTExMDAwMDAwMFoXDTIxMTExMDAw
MDAwMFowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6IItmfnKwkKVpYBzQHDSnlZUXKnE0kEGj8kz/E1FkVyB
n+0snPgWWd+etSQVwpi5tHdJ3InECtqvy15r7a2wcTHrzzpADEZNk+yLejYIA6sMNP4YSYL+x8cx
SIB8HqIPkg5QycaH6zY/2DDD/6b3+6LNb3Mj/qxWBZDwMiEWicZwiPkFl32jx0PdAug7Pe2xQaPt
P77blUjE7h6z8rwMK5nQxl0SQoHhg26Ccz8mSxSQrllmCsSNvtLOBq6thG9IhJtPQLnxTPKvmPv2
zkBdXPao8S+v7Iki8msYZbHBc63X8djPHgp0XEK4aH631XcKJ1Z8D2KkPzIUYJX9BwSiCQIDAQAB
o4IDbzCCA2swDgYDVR0PAQH/BAQDAgGGMDsGA1UdJQQ0MDIGCCsGAQUFBwMBBggrBgEFBQcDAgYI
KwYBBQUHAwMGCCsGAQUFBwMEBggrBgEFBQcDCDCCAcYGA1UdIASCAb0wggG5MIIBtQYLYIZIAYb9
bAEDAAQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJl
cG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAA
dABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAg
AGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMA
UAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABB
AGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkA
dAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBp
AG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMA8GA1UdEwEB/wQFMAMBAf8wfQYIKwYBBQUH
AQEEcTBvMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wRwYIKwYBBQUHMAKG
O2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NBQ2VydHMvRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
Y3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRB
c3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNl
cnRBc3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNV
HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAhGFOQR64dgQq
tbbvj/JVhbldVv4KmObkvWWKfUAp0/yxXUX9OrgqWzNLJFzNubTkc61hXXatdDOKZtUjr0wfcm5F
2XVAu6I7z41JL8BBsOIpo1E4Q1CZFKwzBjViiX13qVIH5WwgV7aBum+8s8KU7XYCgNl8zoWoHOzH
Q0pLsVfPcs7f9SU8yyJP/Z9S0TfLCLs4PuDVPm95Ca1bfDGzdzXD5GP5aAqYB+dGOHeE0j6XvAqg
qKwlT0RukeHSWq9r7zAcjaNEQrMQiyP61+Y1dDesz+urWB/JiCP/NtQH6jRqR+qdlWyeKU9T7eMr
lSBOKs+WYHr4LIDwlVLOKZaBYjCCBv8wggXnoAMCAQICEA2fwUKNhvkL8dN88tUFvVwwDQYJKoZI
hvcNAQEFBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
d3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMB4XDTE0
MDIxNzAwMDAwMFoXDTE1MDMxMjEyMDAwMFowgaQxCzAJBgNVBAYTAkdCMRcwFQYDVQQIEw5DYW1i
cmlkZ2VzaGlyZTESMBAGA1UEBxMJQ2FtYnJpZGdlMRYwFAYDVQQKEw1Db2xsYWJvcmEgTHRkMQow
CAYDVQQLEwExMRYwFAYDVQQDEw1Tam9lcmQgU2ltb25zMSwwKgYJKoZIhvcNAQkBFh1zam9lcmQu
c2ltb25zQGNvbGxhYm9yYS5jby51azCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN4Q
EHeW1NbogMVZpHedG7o509/L4VBhqQd8j8JViWd+yvLlxOBw/gY+7ioHMatrQY2VvY6QOLle2Xqs
CDvELcXMxwyFpBC0Ia+CVE+5pF+0IMuVkGIL1T8LHeKZYeRP+uFXtmWzas12hsMILNRmK7Q5PACm
+v/6HFn111hLKkANBtRHIRiDbFQOiluNeR2bq+ck1y2+X//SGumA1XZFdCB/1VcRJXDdFnYdU3j/
RkoiGggo3MSq3mJ6yV7sqzk04fTLFvfL0KadCMauputeGBybEiFAt6rCm5TkyUqoDOTU07byOEXO
M32EGeYeV515RzARTpOSE9sdmRq0jNNAqGsCAwEAAaOCA2wwggNoMB8GA1UdIwQYMBaAFBUAEisT
mLKZB+0e36K+Vw0rZwLNMB0GA1UdDgQWBBRaTG8RXMDSFO5XcrjqYs/YDlmqSDAoBgNVHREEITAf
gR1zam9lcmQuc2ltb25zQGNvbGxhYm9yYS5jby51azAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2lj
ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdp
Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDCCAcUGA1UdIASCAbwwggG4MIIBtAYK
YIZIAYb9bAQBAjCCAaQwOgYIKwYBBQUHAgEWLmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3NzbC1j
cHMtcmVwb3NpdG9yeS5odG0wggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBzAGUAIABv
AGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBvAG4AcwB0AGkAdAB1AHQA
ZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAgAHQAaABlACAARABpAGcAaQBDAGUAcgB0
ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAgAHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQA
eQAgAEEAZwByAGUAZQBtAGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBp
AGwAaQB0AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABoAGUA
cgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wdwYIKwYBBQUHAQEEazBpMCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNl
cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3J0MAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEFBQADggEBAAc8CwXSms3RbIx+bhxFsGQoN+RpHtjnPvMPPAobv7rxdhQPPz+N
6h3hpVzegeW2XhyZVC8MT0U6uWXrk+1uQUAXrJEG+W2X8yTEoHDS/SCF/POOsj/ekaDuNE9JJB/9
cspoa4W+W8pX1sRurBDFHL0DBudUQ1PgvTSLPOHtfKQpu4gRb2u8KpJermp/IvPLImX9xSCbYKQM
2L0wbpStFIYdyKCKuXuQxOX3BdBKLCFvcIDE6hjj3UpOlThCbeul2Tz5jARCfRK4OUxnXyb/Tp5j
tshIAa2ZMGaTH9ApeY7P6C2ONF+Mh5yV/raWXOnJ9dEg6/sXcbdiieqzLKYBIgQwggb/MIIF56AD
AgECAhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRUwEwYD
VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERp
Z2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTAeFw0xNDAyMTcwMDAwMDBaFw0xNTAzMTIxMjAwMDBaMIGk
MQswCQYDVQQGEwJHQjEXMBUGA1UECBMOQ2FtYnJpZGdlc2hpcmUxEjAQBgNVBAcTCUNhbWJyaWRn
ZTEWMBQGA1UEChMNQ29sbGFib3JhIEx0ZDEKMAgGA1UECxMBMTEWMBQGA1UEAxMNU2pvZXJkIFNp
bW9uczEsMCoGCSqGSIb3DQEJARYdc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28udWswggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDeEBB3ltTW6IDFWaR3nRu6OdPfy+FQYakHfI/CVYln
fsry5cTgcP4GPu4qBzGra0GNlb2OkDi5Xtl6rAg7xC3FzMcMhaQQtCGvglRPuaRftCDLlZBiC9U/
Cx3imWHkT/rhV7Zls2rNdobDCCzUZiu0OTwApvr/+hxZ9ddYSypADQbURyEYg2xUDopbjXkdm6vn
JNctvl//0hrpgNV2RXQgf9VXESVw3RZ2HVN4/0ZKIhoIKNzEqt5iesle7Ks5NOH0yxb3y9CmnQjG
rqbrXhgcmxIhQLeqwpuU5MlKqAzk1NO28jhFzjN9hBnmHledeUcwEU6TkhPbHZkatIzTQKhrAgMB
AAGjggNsMIIDaDAfBgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcNK2cCzTAdBgNVHQ4EFgQUWkxv
EVzA0hTuV3K46mLP2A5ZqkgwKAYDVR0RBCEwH4Edc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28u
dWswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjB9BgNVHR8E
djB0MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0x
LmNybDA4oDagNIYyaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0Et
MS5jcmwwggHFBgNVHSAEggG8MIIBuDCCAbQGCmCGSAGG/WwEAQIwggGkMDoGCCsGAQUFBwIBFi5o
dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUH
AgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABv
AGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABp
AGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkA
bgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBu
AGMAZQAuMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
cmVkSURDQS0xLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4IBAQAHPAsF0prN0WyM
fm4cRbBkKDfkaR7Y5z7zDzwKG7+68XYUDz8/jeod4aVc3oHltl4cmVQvDE9FOrll65PtbkFAF6yR
Bvltl/MkxKBw0v0ghfzzjrI/3pGg7jRPSSQf/XLKaGuFvlvKV9bEbqwQxRy9AwbnVENT4L00izzh
7XykKbuIEW9rvCqSXq5qfyLzyyJl/cUgm2CkDNi9MG6UrRSGHcigirl7kMTl9wXQSiwhb3CAxOoY
491KTpU4Qm3rpdk8+YwEQn0SuDlMZ18m/06eY7bISAGtmTBmkx/QKXmOz+gtjjRfjIeclf62llzp
yfXRIOv7F3G3YonqsyymASIEMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2Vy
dCBBc3N1cmVkIElEIENBLTECEA2fwUKNhvkL8dN88tUFvVwwCQYFKw4DAhoFAKCCAW8wGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTExMDgwMDI5WjAjBgkqhkiG
9w0BCQQxFgQUL3JYMYSlCTFfx8fUnnF4rJIG0oswgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEh
MB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xAhANn8FCjYb5C/HTfPLVBb1cMIGHBgsq
hkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0x
AhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBAQUABIIBAHXPdTHHsU6/EeX2+srTkg8KkXj3
G5JirQv3CV0R8AYB5cuoTnjCxlLWEl1TldMSOPU32ADxdbbmONj60lez21RXgoC4tExUZNYbxShf
iTc9x3HW4GAhQ+zJs3eoEBcK2d5Fttj2hXq6C6ndYbR/Y/bGZ7MUIXs5BuYuCmYlDKz73SpZ8RMU
OHHPZMqL4erqvpNQcbHDAMGCXnyEKpZYoI6G5rLgIPHFRpyUSzF1kJsSAO9rscQKeuJlnQmO7CYB
vBFBuP6jb/7W9GEIH6GLcYtlefrpnViQDmV2yR7liX8jWuee62Uw1MHjYfa8ozV4U+VkFSAc9/jm
YnQAUrguVsYAAAAAAAA=


--=-R9N8fwdhAHJ/3xxDAwlh--

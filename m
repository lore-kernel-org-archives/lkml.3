Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3KAAIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:08:32 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46464 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3KAAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAAf88o+3ZeUz+oavvojP1VuWJfR2NevUw5ypJ0PAJjJS9TushQ@mail.gmail.com>
References: <CAAf88o+3ZeUz+oavvojP1VuWJfR2NevUw5ypJ0PAJjJS9TushQ@mail.gmail.com>
Date: Fri, 1 Nov 2013 01:08:27 +0100
Message-ID: <CAAf88oLobjAcewxYDup8Lpo6E9XMCj7DmFiFcYu9c+ZGP4sLhA@mail.gmail.com>
Subject: Fwd: Driver for touchscreen BF6931A1 instead S2100A
From: Grzegorz Hetman <ghetman@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec53aedb29d715404ea125d62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec53aedb29d715404ea125d62
Content-Type: text/plain; charset=ISO-8859-1

Hi there :)

I replace digitizer in my phone (Huawei u8815), but its based on
BF6931A1 instead S2100A.

BF6931A1 is not proper initialized by driver. It start fail on
synaptics_rmi4_read_pdt where
ret = i2c_smbus_write_byte_data(ts->client, 0xff, 0x00); is called
(set rmi page to zero).

Its just the first symptom where i see that the i2c communication fail.

I try on many way to reset this chip by software but without success:

Dmesg part when the BF6931A1 chip is connected:
<6>[1, swapper] [    1.083416] rmi_bus_init: RMI Bus Driver Init
<7>[1, swapper] [    1.083533] rmi_bus_init: registered bus.
<7>[1, swapper] [    1.083559] rmi_sensor_init: RMI Sensor Init
<7>[1, swapper] [    1.083578] rmi_function_init: RMI Function Init
<4>[1, swapper] [    1.083688] i2c-core: driver [rmi4_ts] using legacy
suspend method
<4>[1, swapper] [    1.083718] i2c-core: driver [rmi4_ts] using legacy
resume method
<4>[1, swapper] [    1.083804] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    1.083833] Client adress is: 70
<6>[1, swapper] [    1.083856] the i2c_check_functionality is ok
<3>[1, swapper] [    1.083888] synaptics_rmi4_probe: it's the first
touch driver!
<3>[1, swapper] [    1.150668] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[1, swapper] [    1.151383] failed to set rmi page
<3>[1, swapper] [    1.151428] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[1, swapper] [    1.152136] I2C read failed querying RMI4 $70 capabilities
<3>[1, swapper] [    1.152164] Error identifying device (-5)
<4>[60, synaptics_wq] [    1.152218] do_exit: exit code=4294967292
<4>[60, synaptics_wq] [    1.152271] synaptics_wq used greatest stack
depth: 6552 bytes left
<4>[1, swapper] [    1.152424] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    1.152456] Client adress is: 24
<6>[1, swapper] [    1.152478] the i2c_check_functionality is ok
<3>[1, swapper] [    1.152509] synaptics_rmi4_probe: it's the first
touch driver!
<7>[1, swapper] [    1.152539] gpio_request: gpio-96 (TOUCH_RESET) status -16
<3>[1, swapper] [    1.218838] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[1, swapper] [    1.219549] failed to set rmi page
<3>[1, swapper] [    1.219591] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[1, swapper] [    1.220299] I2C read failed querying RMI4 $24 capabilities
<3>[1, swapper] [    1.220326] Error identifying device (-5)

And now how its look with original S2100A:

<6>[1, swapper] [    1.039414] rmi_bus_init: RMI Bus Driver Init
<7>[1, swapper] [    1.039529] rmi_bus_init: registered bus.
<7>[1, swapper] [    1.039556] rmi_sensor_init: RMI Sensor Init
<7>[1, swapper] [    1.039576] rmi_function_init: RMI Function Init
<4>[1, swapper] [    1.039683] i2c-core: driver [rmi4_ts] using legacy
suspend method
<4>[1, swapper] [    1.039713] i2c-core: driver [rmi4_ts] using legacy
resume method
<4>[1, swapper] [    1.039798] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    1.039828] Client adress is: 70
<6>[1, swapper] [    1.039851] the i2c_check_functionality is ok
<3>[1, swapper] [    1.039883] synaptics_rmi4_probe: it's the first
touch driver!
<4>[1, swapper] [    1.106931] set rmi page to zero successfull
<6>[1, swapper] [    1.111396] 2 fingers
<6>[1, swapper] [    1.111419] EGR features:
<6>[1, swapper] [    1.111441]  pinch: 0
<6>[1, swapper] [    1.111463]  press: 0
<6>[1, swapper] [    1.111483]  flick: 0
<6>[1, swapper] [    1.111503]  early tap: 0
<6>[1, swapper] [    1.111524]  double tap: 0
<6>[1, swapper] [    1.111544]  tap and hold: 0
<6>[1, swapper] [    1.111566]  single tap: 1
<6>[1, swapper] [    1.111588]  palm detect: 0
<6>[1, swapper] [    1.113298] max X: 1068; max Y: 1868
<6>[1, swapper] [    1.114231] Read 0 functions from PDT
<3>[1, swapper] [    1.114256] RMI4 $70 data read: $13 + 15
<6>[1, swapper] [    1.116009] the ReportingMode is changged ok!
<6>[1, swapper] [    1.116376] input: synaptics as /devices/virtual/input/input0
<6>[1, swapper] [    1.116594] synaptics input device registered
<7>[1, swapper] [    1.116696] gpio_request: gpio-146 (Synaptics_rmi) status -22
<7>[1, swapper] [    1.116721] gpio_direction_input: gpio-146 status -22
<6>[1, swapper] [    1.116738] Requesting IRQ...
<6>[1, swapper] [    1.116828] Received IRQ!
<3>[1, swapper] [    1.116868] probingX for Synaptics RMI4 device
Synaptics_rmi at $70...
<4>[1, swapper] [    1.116928] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    1.116958] Client adress is: 24
<6>[1, swapper] [    1.116979] the i2c_check_functionality is ok
<3>[1, swapper] [    1.117011] synaptics_rmi4_probe: the touch driver
has detected :)
<4>[1, swapper] [    1.117054] Synaptics_rmi: probe of 1-0024 failed
with error -1

How we can see set rmi page to zero is successfull and also reading
capabilities are fine: RMI4 $70 data read: $13 + 15

Now when I switch(without rebooting) again to BF6931A1 I`m able to use
my touchscreen without any issues!

Now its time to reboot phone and see what dmesg show:

<6>[1, swapper] [    1.039468] rmi_bus_init: RMI Bus Driver Init
<7>[1, swapper] [    1.039583] rmi_bus_init: registered bus.
<7>[1, swapper] [    1.039609] rmi_sensor_init: RMI Sensor Init
<7>[1, swapper] [    1.039628] rmi_function_init: RMI Function Init
<4>[1, swapper] [    1.039736] i2c-core: driver [rmi4_ts] using legacy
suspend method
<4>[1, swapper] [    1.039764] i2c-core: driver [rmi4_ts] using legacy
resume method
<4>[1, swapper] [    1.039851] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    1.039879] Client adress is: 70
<6>[1, swapper] [    1.039903] the i2c_check_functionality is ok
<3>[1, swapper] [    1.039934] synaptics_rmi4_probe: it's the first
touch driver!
<4>[1, swapper] [    1.106981] set rmi page to zero successfull
<6>[1, swapper] [    1.111361] 2 fingers
<6>[1, swapper] [    1.111384] EGR features:
<6>[1, swapper] [    1.111406]  pinch: 0
<6>[1, swapper] [    1.111426]  press: 0
<6>[1, swapper] [    1.111448]  flick: 0
<6>[1, swapper] [    1.111468]  early tap: 0
<6>[1, swapper] [    1.111489]  double tap: 0
<6>[1, swapper] [    1.111509]  tap and hold: 0
<6>[1, swapper] [    1.111531]  single tap: 1
<6>[1, swapper] [    1.111553]  palm detect: 0
<6>[1, swapper] [    1.113243] max X: 1036; max Y: 1904
<6>[1, swapper] [    1.114176] Read 0 functions from PDT
<3>[1, swapper] [    1.114203] RMI4 $70 data read: $13 + 15
<7>[18, kworker/0:1] [    1.254419] gpio_request: gpio-141
(i2c_host_vbus_en) status -22
<3>[18, kworker/0:1] [    1.254443] failed to request 141 GPIO
<6>[18, kworker/0:1] [    1.354574] msm_hsusb_host msm_hsusb_host.0:
Qualcomm On-Chip EHCI Host Controller
<6>[18, kworker/0:1] [    1.354644] msm_hsusb_host msm_hsusb_host.0:
new USB bus registered, assigned bus number 1
<6>[18, kworker/0:1] [    1.354824] msm_hsusb_host msm_hsusb_host.0:
irq 47, io base 0xa0800000
<6>[18, kworker/0:1] [    1.354996] usb usb1: New USB device found,
idVendor=1d6b, idProduct=0002
<6>[18, kworker/0:1] [    1.355034] usb usb1: New USB device strings:
Mfr=3, Product=2, SerialNumber=1
<6>[18, kworker/0:1] [    1.355069] usb usb1: Product: Qualcomm
On-Chip EHCI Host Controller
<6>[18, kworker/0:1] [    1.355099] usb usb1: Manufacturer: Linux
3.0.8-perf ehci_hcd
<6>[18, kworker/0:1] [    1.355129] usb usb1: SerialNumber: msm_hsusb_host.0
<6>[18, kworker/0:1] [    1.355879] hub 1-0:1.0: USB hub found
<6>[18, kworker/0:1] [    1.355934] hub 1-0:1.0: 1 port detected
<6>[18, kworker/0:1] [    1.356509] msm_hsusb_host msm_hsusb_host.0:
remove, state 1
<6>[18, kworker/0:1] [    1.356561] usb usb1: USB disconnect, device number 1
<6>[18, kworker/0:1] [    1.374768] msm_hsusb_host msm_hsusb_host.0:
USB bus 1 deregistered
<7>[18, kworker/0:1] [    1.604413] gpio_request: gpio-141
(i2c_host_vbus_en) status -22
<3>[18, kworker/0:1] [    1.604451] failed to request 141 GPIO
<3>[1, swapper] [    2.144336] qup_i2c qup_i2c.1: Transaction timed
out, SL-AD = 0x70
<3>[1, swapper] [    2.144371] qup_i2c qup_i2c.1: I2C Status: 349b00
<3>[1, swapper] [    2.144398] qup_i2c qup_i2c.1: QUP Status: 0
<3>[1, swapper] [    2.144424] qup_i2c qup_i2c.1: OP Flags: 0
<4>[1, swapper] [    2.144458] Failed to read IC name.
<3>[1, swapper] [    2.144506] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[1, swapper] [    2.145221] tp_read_input_name: i2c_transfer failed
at address $70
<6>[1, swapper] [    2.145286] the ReportingMode is changged ok!
<6>[1, swapper] [    2.145656] input: synaptics as /devices/virtual/input/input0
<6>[1, swapper] [    2.145863] synaptics input device registered
<7>[1, swapper] [    2.145963] gpio_request: gpio-146 (Synaptics_rmi) status -22
<7>[1, swapper] [    2.145986] gpio_direction_input: gpio-146 status -22
<6>[1, swapper] [    2.146004] Requesting IRQ...
<6>[1, swapper] [    2.146093] Received IRQ!
<3>[1, swapper] [    2.146129] probingX for Synaptics RMI4 device
Synaptics_rmi at $70...
<4>[1, swapper] [    2.146193] *************** synaptics_rmi4_probe
******************
<4>[1, swapper] [    2.146223] Client adress is: 24
<6>[1, swapper] [    2.146244] the i2c_check_functionality is ok
<3>[1, swapper] [    2.146276] synaptics_rmi4_probe: the touch driver
has detected :)
<4>[1, swapper] [    2.146316] Synaptics_rmi: probe of 1-0024 failed
with error -1

As we can see after reboot driver was able to set rmi page to zero abd
read capabilities.
Unfortunate In this moment my touchscreen is not responding and in
dmesg i see a lot of:

<3>[19, kworker/u:1] [  290.841264] synaptics_rmi4_work_func:
i2c_transfer failed
<3>[19, kworker/u:1] [  290.841343] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43
<3>[19, kworker/u:1] [  290.841869] synaptics_rmi4_work_func:
i2c_transfer failed
<3>[19, kworker/u:1] [  290.844888] qup_i2c qup_i2c.1: QUP: I2C status
flags :0x1121c4, irq:43

This state is until i reconnect BF6931A1, (still the same without
connecting the old S2100A).
Now again works fine.

Then when re-flash new kernel (and sometimes when I disconnect all
power) its a big chance to back to state from first dmesg.


In attachment i put my latest code.

Maybe somebody here have idea what i can do else (maybe some hardware
reset of i2c or other magic).

General i`m opened on any tip.

Best Regards,
Grzegorz Hetman.

--bcaec53aedb29d715404ea125d62
Content-Type: text/x-csrc; charset=US-ASCII; name="synaptics_i2c_rmi_1564.c"
Content-Disposition: attachment; filename="synaptics_i2c_rmi_1564.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hngnh5rb0

Ci8qIGRyaXZlcnMvaW5wdXQva2V5Ym9hcmQvc3luYXB0aWNzX2kyY19ybWkuYwogKgogKiBDb3B5
cmlnaHQgKEMpIDIwMDcgR29vZ2xlLCBJbmMuCiAqIENvcHlyaWdodCAoQykgMjAwOCBUZXhhcyBJ
bnN0cnVtZW50IEluYy4KICogQ29weXJpZ2h0IChDKSAyMDA5IFN5bmFwdGljcywgSW5jLgogKgog
KiBwcm92aWRlcyBkZXZpY2UgZmlsZXMgL2Rldi9pbnB1dC9ldmVudCMKICogZm9yIG5hbWVkIGRl
dmljZSBmaWxlcywgdXNlIHVkZXYKICogMkQgc2Vuc29ycyByZXBvcnQgQUJTX1hfRklOR0VSKDAp
LCBBQlNfWV9GSU5HRVIoMCkgdGhyb3VnaCBBQlNfWF9GSU5HRVIoNyksIEFCU19ZX0ZJTkdFUig3
KQogKiBOT1RFOiByZXF1aXJlcyB1cGRhdGVkIGlucHV0LmgsIHdoaWNoIHNob3VsZCBiZSBpbmNs
dWRlZCB3aXRoIHRoaXMgZHJpdmVyCiAqIDFEL0J1dHRvbnMgcmVwb3J0IEJUTl8wIHRocm91Z2gg
QlROXzAgKyBidXR0b25fY291bnQKICogVE9ETzogcmVwb3J0IFJFTF9YLCBSRUxfWSBmb3IgZmxp
Y2ssIEJUTl9UT1VDSCBmb3IgdGFwIChvbiAxRC8wRDsgZG9uZSBmb3IgMkQpCiAqIFRPRE86IGNo
ZWNrIGlvY3RsIChFVklPQ0dBQlMpIHRvIHF1ZXJ5IDJEIG1heCBYICYgWSwgMUQgYnV0dG9uIGNv
dW50CiAqCiAqIFRoaXMgc29mdHdhcmUgaXMgbGljZW5zZWQgdW5kZXIgdGhlIHRlcm1zIG9mIHRo
ZSBHTlUgR2VuZXJhbCBQdWJsaWMKICogTGljZW5zZSB2ZXJzaW9uIDIsIGFzIHB1Ymxpc2hlZCBi
eSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBhbmQKICogbWF5IGJlIGNvcGllZCwgZGlz
dHJpYnV0ZWQsIGFuZCBtb2RpZmllZCB1bmRlciB0aG9zZSB0ZXJtcy4KICoKICogVGhpcyBwcm9n
cmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCiAq
IGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJh
bnR5IG9mCiAqIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVS
UE9TRS4gIFNlZSB0aGUKICogR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0
YWlscy4KICoKICovCgovKiBtb2RpZnkgZm9yIDQxMjUgYmFzZWxpbmUgKi8KI2luY2x1ZGUgPGxp
bnV4L3NsYWIuaD4KI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgojaW5jbHVkZSA8bGludXgvaW5w
dXQuaD4KI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPgojaW5jbHVkZSA8bGludXgvaHJ0aW1l
ci5oPgojaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+CiNpbmNsdWRlIDxsaW51eC9p
MmMuaD4KI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CiNpbmNsdWRlIDxsaW51eC9zeW5hcHRpY3Nf
aTJjX3JtaV8xNTY0Lmg+CiNpbmNsdWRlIDxsaW51eC9pby5oPgojaW5jbHVkZSA8bGludXgvZ3Bp
by5oPgojaW5jbHVkZSA8bGludXgvZWFybHlzdXNwZW5kLmg+CiNpbmNsdWRlIDxsaW51eC9kZXZp
Y2UuaD4KI2luY2x1ZGUgPG1hY2gvdnJlZy5oPgojaW5jbHVkZSA8bWFjaC9ncGlvLmg+CgovKmlu
Y2x1ZGUgdGhlIC5oIGZpbGUqLwojaW5jbHVkZSA8bGludXgvcHJvY19mcy5oPgojaW5jbHVkZSA8
bGludXgvdG91Y2hfcGxhdGZvcm1fY29uZmlnLmg+CiNpZmRlZiBDT05GSUdfSFVBV0VJX0hXX0RF
Vl9EQ1QKI2luY2x1ZGUgPGxpbnV4L2h3X2Rldl9kZWMuaD4KI2VuZGlmCiNkZWZpbmUgQ09ORklH
X1NZTkFQVElDU19VUERBVEVfUk1JX1RTX0ZJUk1XQVJFCiNpZmRlZiBDT05GSUdfU1lOQVBUSUNT
X1VQREFURV9STUlfVFNfRklSTVdBUkUKI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CiNpbmNsdWRlIDxh
c20vdWFjY2Vzcy5oPgojaW5jbHVkZSA8bGludXgvbmFtZWkuaD4KI2luY2x1ZGUgPGxpbnV4L3Zt
YWxsb2MuaD4KI2VuZGlmCiNkZWZpbmUgREVWX0FUVFIoX3ByZSwgX25hbWUsIF9tb2RlKSBcCkRF
VklDRV9BVFRSKF9wcmUjI18jI19uYW1lLF9tb2RlLF9wcmUjI18jI19uYW1lIyNfc2hvdyxfcHJl
IyNfIyNfbmFtZSMjX3N0b3JlKQoKI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgojaW5jbHVkZSA8
YXNtL21hY2gtdHlwZXMuaD4KI2luY2x1ZGUgImxpbnV4L2hhcmR3YXJlX3NlbGZfYWRhcHQuaCIK
I2RlZmluZSBCVE5fRjE5IEJUTl8wCiNkZWZpbmUgQlROX0YzMCBCVE5fMAojZGVmaW5lIFNDUk9M
TF9PUklFTlRBVElPTiBSRUxfWQoKLyoKLy8jZGVmaW5lIFRTX1JNSV9ERUJVRwojdW5kZWYgVFNf
Uk1JX0RFQlVHIAojaWZkZWYgVFNfUk1JX0RFQlVHCiNkZWZpbmUgVFNfREVCVUdfUk1JKGZtdCwg
YXJncy4uLikgcHJpbnRrKEtFUk5fSU5GTyBmbXQsICMjYXJncykKI2Vsc2UKI2RlZmluZSBUU19E
RUJVR19STUkoZm10LCBhcmdzLi4uKQojZW5kaWYKKi8KCiNkZWZpbmUgVFNfREVCVUdfUk1JKGZt
dCwgYXJncy4uLikgcHJpbnRrKEtFUk5fSU5GTyBmbXQsICMjYXJncykKCi8vIHByb3RveXBlcyxl
bHNlIHRoZSBzdHJ1Y3R1cmUgaW5pdGlhbGl6YXRpb24gdGhhdCBmb2xsb3dzIGZhaWwKc3RhdGlj
IGludCBkZXZfb3BlbihzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGZpbGUgKik7CnN0YXRpYyBpbnQg
ZGV2X3JscyhzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGZpbGUgKik7CnN0YXRpYyBzc2l6ZV90IGRl
dl9yZWFkKHN0cnVjdCBmaWxlICosIGNoYXIgKiwgc2l6ZV90LCBsb2ZmX3QgKik7CnN0YXRpYyBz
c2l6ZV90IGRldl93cml0ZShzdHJ1Y3QgZmlsZSAqLCBjb25zdCBjaGFyICosIHNpemVfdCwgbG9m
Zl90ICopOwpzdHJ1Y3QgaTJjX2NsaWVudCAqZ2xvYmFsX2NsaWVudDsKCiNpZmRlZiBDT05GSUdf
U1lOQVBUSUNTX1VQREFURV9STUlfVFNfRklSTVdBUkUKI2RlZmluZSBTWU5BUElUSUNTX0RFQlVH
KGZtdCwgYXJncy4uLikgcHJpbnRrKEtFUk5fREVCVUcgZm10LCAjI2FyZ3MpCnN0YXRpYyBzdHJ1
Y3QgaTJjX2NsaWVudCAqZ19jbGllbnQgPSBOVUxMOwpzdGF0aWMgc3NpemVfdCB1cGRhdGVfZmly
bXdhcmVfc2hvdyhzdHJ1Y3Qga29iamVjdCAqa29iaiwgc3RydWN0IGtvYmpfYXR0cmlidXRlICph
dHRyLGNoYXIgKmJ1Zik7CnN0YXRpYyBzc2l6ZV90IHVwZGF0ZV9maXJtd2FyZV9zdG9yZShzdHJ1
Y3Qga29iamVjdCAqa29iaiwgc3RydWN0IGtvYmpfYXR0cmlidXRlICphdHRyLCBjb25zdCBjaGFy
ICpidWYsIHNpemVfdCBjb3VudCk7CgpzdGF0aWMgaW50IHRzX2Zpcm13YXJlX2ZpbGUodm9pZCk7
CnN0YXRpYyBpbnQgaTJjX3VwZGF0ZV9maXJtd2FyZShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
KTsgCgpzdGF0aWMgc3RydWN0IGtvYmpfYXR0cmlidXRlIHVwZGF0ZV9maXJtd2FyZV9hdHRyaWJ1
dGUgPSB7CgkuYXR0ciA9IHsubmFtZSA9ICJ1cGRhdGVfZmlybXdhcmUiLCAubW9kZSA9IDA2NjR9
LAoJLnNob3cgPSB1cGRhdGVfZmlybXdhcmVfc2hvdywKCS5zdG9yZSA9IHVwZGF0ZV9maXJtd2Fy
ZV9zdG9yZSwKfTsKI2VuZGlmIC8qIENPTkZJR19TWU5BUFRJQ1NfVVBEQVRFX1JNSV9UU19GSVJN
V0FSRSAqLwpzdGF0aWMgaW50IHN5bmFwdGljc19kZWJ1Z19tYXNrOwptb2R1bGVfcGFyYW1fbmFt
ZWQoc3luYXB0aWNzX2RlYnVnLCBzeW5hcHRpY3NfZGVidWdfbWFzaywgaW50LAoJCVNfSVJVR08g
fCBTX0lXVVNSIHwgU19JV0dSUCk7CgojZGVmaW5lIERCR19NQVNLKHguLi4pIGRvIHtcCglpZiAo
c3luYXB0aWNzX2RlYnVnX21hc2spIFwKCQlwcmludGsoS0VSTl9ERUJVRyB4KTtcCgl9IHdoaWxl
ICgwKQoKCnN0YXRpYyBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqc3luYXB0aWNzX3dxOwoJCnN0
YXRpYyBzdHJ1Y3Qgc3luYXB0aWNzX3JtaTQgKnRzID0gTlVMTDsKCgojZGVmaW5lIEVHUl9QSU5D
SF9SRUcJCTAKI2RlZmluZSBFR1JfUElOQ0ggCQkoMSA8PCA2KQojZGVmaW5lIEVHUl9QUkVTU19S
RUcgCQkwCiNkZWZpbmUgRUdSX1BSRVNTIAkJKDEgPDwgNSkKI2RlZmluZSBFR1JfRkxJQ0tfUkVH
IAkJMAojZGVmaW5lIEVHUl9GTElDSyAJCSgxIDw8IDQpCiNkZWZpbmUgRUdSX0VBUkxZX1RBUF9S
RUcJMAojZGVmaW5lIEVHUl9FQVJMWV9UQVAJCSgxIDw8IDMpCiNkZWZpbmUgRUdSX0RPVUJMRV9U
QVBfUkVHCTAKI2RlZmluZSBFR1JfRE9VQkxFX1RBUAkJKDEgPDwgMikKI2RlZmluZSBFR1JfVEFQ
X0FORF9IT0xEX1JFRwkwCiNkZWZpbmUgRUdSX1RBUF9BTkRfSE9MRAkoMSA8PCAxKQojZGVmaW5l
IEVHUl9TSU5HTEVfVEFQX1JFRwkwCiNkZWZpbmUgRUdSX1NJTkdMRV9UQVAJCSgxIDw8IDApCi8q
IFJlZ2lzdGVyOiBFR1JfMSAqLwojZGVmaW5lIEVHUl9QQUxNX0RFVEVDVF9SRUcJMQojZGVmaW5l
IEVHUl9QQUxNX0RFVEVDVAkJKDEgPDwgMCkKCgoKI2RlZmluZSBGSU5HRVJfTUFYIDkKI2RlZmlu
ZSBGSU5HRVJfQ05UIChGSU5HRVJfTUFYKzEpCiNkZWZpbmUgU1lOQVBUSUNTX0kyQ19STUlfTkFN
RSAiU3luYXB0aWNzX1JNSTQiCgoKCgoKI2RlZmluZSBBQlNfWEYJCQkwCiNkZWZpbmUgQUJTX1lG
CQkJMQojZGVmaW5lIEFCU19aRgkJCTIKI2RlZmluZSBFVkVOVFNfUEVSX0ZJTkdFUgkzCiNkZWZp
bmUgQUJTX0ZJTkdFUihmKQkJKDB4MjkgKyBFVkVOVFNfUEVSX0ZJTkdFUiAqIGYpCgojZGVmaW5l
IEFCU19YX0ZJTkdFUihmKQkJKEFCU19GSU5HRVIoZikgKyBBQlNfWEYpCiNkZWZpbmUgQUJTX1lf
RklOR0VSKGYpCQkoQUJTX0ZJTkdFUihmKSArIEFCU19ZRikKI2RlZmluZSBBQlNfWl9GSU5HRVIo
ZikJCShBQlNfRklOR0VSKGYpICsgQUJTX1pGKQojZGVmaW5lIEFCU19DTlQJCQkoQUJTX01BWCsx
KQoKCnN0cnVjdCBzeW5hcHRpY3NfZnVuY3Rpb25fZGVzY3JpcHRvciB7CglfX3U4IHF1ZXJ5QmFz
ZTsKCV9fdTggY29tbWFuZEJhc2U7CglfX3U4IGNvbnRyb2xCYXNlOwoJX191OCBkYXRhQmFzZTsK
CV9fdTggaW50U3JjOwojZGVmaW5lIEZVTkNUSU9OX1ZFUlNJT04oeCkgKCh4ID4+IDUpICYgMykK
I2RlZmluZSBJTlRFUlJVUFRfU09VUkNFX0NPVU5UKHgpICh4ICYgNykKCglfX3U4IGZ1bmN0aW9u
TnVtYmVyOwp9OwojZGVmaW5lIEZEX0FERFJfTUFYIDB4RTkKI2RlZmluZSBGRF9BRERSX01JTiAw
eDA1CiNkZWZpbmUgRkRfQllURV9DT1VOVCA2CgoKI2RlZmluZSBCWUQgICAgIDEKI2RlZmluZSBD
TUkgICAgIDIKI2RlZmluZSBUUlVMWSAgIDMKI2RlZmluZSBUUEsgICAgIDQKI2RlZmluZSBMRU5T
T05FIDUKI2RlZmluZSBPRklMTSAgIDYKI2RlZmluZSBFRUxZICAgIDcKI2RlZmluZSBTVUNDRVNT
IDgKI2RlZmluZSBBTFBTICAgIDkKCnN0YXRpYyB1MTYgdG91Y2hfaWNfbmFtZSA9IDA7CnN0YXRp
YyBjaGFyIHRvdWNoX2luZm9bNTBdID0gezB9OwoKc3RhdGljIGludCBSTUk0X2VuYWJsZV9wcm9n
cmFtKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQpOwppbnQgUk1JNF9kaXNhYmxlX3Byb2dyYW0o
c3RydWN0IGkyY19jbGllbnQgKmNsaWVudCk7CnN0YXRpYyBzdHJ1Y3Qgc3luYXB0aWNzX2Z1bmN0
aW9uX2Rlc2NyaXB0b3IgZmRfMzQ7CgpzdGF0aWMgc3RydWN0IHN5bmFwdGljc19mdW5jdGlvbl9k
ZXNjcmlwdG9yIGZkXzAxOwpzdGF0aWMgc3RydWN0IGkyY19tc2cgcXVlcnlfaTJjX21zZ19uYW1l
WzJdOwpzdGF0aWMgX191OCBxdWVyeV9uYW1lWzhdOwoKc3RhdGljIGludCB0c194X21heCA9IDA7
CnN0YXRpYyBpbnQgdHNfeV9tYXggPSAwOwpzdGF0aWMgaW50IGxjZF94ID0gMDsKc3RhdGljIGlu
dCBsY2RfeSA9IDA7CnN0YXRpYyBpbnQgbGNkX2FsbCA9IDA7CnN0YXRpYyBfX3U4IHBvaW50X3N1
cHBvcnRlZF9odWF3ZWkgPSAwOwoKZXh0ZXJuIHN0cnVjdCBpMmNfZGV2aWNlX2lkIHN5bmFwdGlj
c19ybWk0X2lkW107CgojaWZkZWYgQ09ORklHX0hBU19FQVJMWVNVU1BFTkQKc3RhdGljIHZvaWQg
c3luYXB0aWNzX3JtaTRfZWFybHlfc3VzcGVuZChzdHJ1Y3QgZWFybHlfc3VzcGVuZCAqaCk7CnN0
YXRpYyB2b2lkIHN5bmFwdGljc19ybWk0X2xhdGVfcmVzdW1lKHN0cnVjdCBlYXJseV9zdXNwZW5k
ICpoKTsKI2VuZGlmCgovKlByb3RvdHlwZXMgKi8Kc3RhdGljIGludCBzeW5hcHRpY3Nfcm1pNF9z
dXNwZW5kKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsIHBtX21lc3NhZ2VfdCBtZXNnKTsKc3Rh
dGljIGludCBzeW5hcHRpY3Nfcm1pNF9yZXN1bWUoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCk7
Cgp1MTIgY2hlY2tfc2NvcGVfWCh1MTIgeCkKewoJdTEyIHRlbXAgPSB4OwoJaWYgKHggPj0gbGNk
X3ggLTEpCgl7CgkJdGVtcCA9IGxjZF94IC0yOwoJfQoJaWYgKHggPD0gMSkKCXsKCQl0ZW1wID0g
MTsKCX0KCglyZXR1cm4gdGVtcDsKfQoKc3RhdGljIGludCBzeW5hcHRpY3Nfcm1pNF9yZWFkX3Bk
dChzdHJ1Y3Qgc3luYXB0aWNzX3JtaTQgKnRzKQp7CiAgICBpbnQgcmV0ID0gMDsKICAgIGludCBu
RmQgPSAwOwogICAgaW50IGludGVycnVwdENvdW50ID0gMDsKICAgIHN0cnVjdCBpMmNfbXNnIGZk
X2kyY19tc2dbMl07CiAgICBzdHJ1Y3QgaTJjX21zZyBxdWVyeV9pMmNfbXNnWzJdOwogICAgc3Ry
dWN0IHN5bmFwdGljc19mdW5jdGlvbl9kZXNjcmlwdG9yIGZkOwogICAgX191OCBkYXRhX2xlbmd0
aCA9IDA7CiAgICBfX3U4IGZkX3JlZzsKICAgIF9fdTggcXVlcnlbMTRdOwogICAgX191OCAqZWdy
OwoKICAgIC8qIGNoZWNrIHdoZXRoZXIgcm1pIHBhZ2UgaXMgMCAqLwogICAgcHJpbnRrKCJcMDMz
WzIyOzMxbSBPSyBzcHJhd2R6YW15IHJtaSBwYWdlLi4uIFwwMzNbMDE7MG1cbiIpOwogICAgCiAg
ICByZXQgPSBpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKHRzLT5jbGllbnQsIDB4ZmYsIDB4MDAp
OwoKICAgIGlmKHJldCA8IDApIHsKICAgICAgICBwcmludGsoS0VSTl9FUlIgImZhaWxlZCB0byBz
ZXQgcm1pIHBhZ2VcbiIpOwogICAgfSBlbHNlIHsKICAgICAgICBwcmludGsoInNldCBybWkgcGFn
ZSB0byB6ZXJvIHN1Y2Nlc3NmdWxsXG4iKTsKICAgIH0KCiAgICBmZF9pMmNfbXNnWzBdLmFkZHIg
PSB0cy0+Y2xpZW50LT5hZGRyOwogICAgZmRfaTJjX21zZ1swXS5mbGFncyA9IDA7CiAgICBmZF9p
MmNfbXNnWzBdLmJ1ZiA9ICZmZF9yZWc7CiAgICBmZF9pMmNfbXNnWzBdLmxlbiA9IDE7CgogICAg
ZmRfaTJjX21zZ1sxXS5hZGRyID0gdHMtPmNsaWVudC0+YWRkcjsKICAgIGZkX2kyY19tc2dbMV0u
ZmxhZ3MgPSBJMkNfTV9SRDsKICAgIGZkX2kyY19tc2dbMV0uYnVmID0gKF9fdTggKikoJmZkKTsK
ICAgIGZkX2kyY19tc2dbMV0ubGVuID0gRkRfQllURV9DT1VOVDsKCiAgICBxdWVyeV9pMmNfbXNn
WzBdLmFkZHIgPSB0cy0+Y2xpZW50LT5hZGRyOwogICAgcXVlcnlfaTJjX21zZ1swXS5mbGFncyA9
IDA7CiAgICBxdWVyeV9pMmNfbXNnWzBdLmJ1ZiA9ICZmZC5xdWVyeUJhc2U7CiAgICBxdWVyeV9p
MmNfbXNnWzBdLmxlbiA9IDE7CgogICAgcXVlcnlfaTJjX21zZ1sxXS5hZGRyID0gdHMtPmNsaWVu
dC0+YWRkcjsKICAgIHF1ZXJ5X2kyY19tc2dbMV0uZmxhZ3MgPSBJMkNfTV9SRDsKICAgIHF1ZXJ5
X2kyY19tc2dbMV0uYnVmID0gcXVlcnk7CiAgICBxdWVyeV9pMmNfbXNnWzFdLmxlbiA9IHNpemVv
ZihxdWVyeSk7CgogICAgdHMtPmhhc0YxMSA9IGZhbHNlOwogICAgdHMtPmhhc0YxOSA9IGZhbHNl
OwogICAgdHMtPmhhc0YzMCA9IGZhbHNlOwogICAgdHMtPmRhdGFfcmVnID0gMHhmZjsKICAgIHRz
LT5kYXRhX2xlbmd0aCA9IDA7CgogICAgZm9yIChmZF9yZWcgPSBGRF9BRERSX01BWDsgZmRfcmVn
ID49IEZEX0FERFJfTUlOOyBmZF9yZWcgLT0gRkRfQllURV9DT1VOVCl7CiAgICAgICAgcmV0ID0g
aTJjX3RyYW5zZmVyKHRzLT5jbGllbnQtPmFkYXB0ZXIsIGZkX2kyY19tc2csIDIpOwogICAgICAg
IGlmIChyZXQgPCAwKXsKICAgICAgICAgICAgcHJpbnRrKEtFUk5fRVJSICJJMkMgcmVhZCBmYWls
ZWQgcXVlcnlpbmcgUk1JNCAkJTAyWCBjYXBhYmlsaXRpZXNcbiIsIHRzLT5jbGllbnQtPmFkZHIp
OwogICAgICAgICAgICByZXR1cm4gcmV0OwogICAgICAgIH0KCiAgICAgICAgaWYgKCFmZC5mdW5j
dGlvbk51bWJlcil7CiAgICAgICAgICAgIC8qIEVuZCBvZiBQRFQgKi8KICAgICAgICAgICAgcmV0
ID0gbkZkOwogICAgICAgICAgICBUU19ERUJVR19STUkoIlJlYWQgJWQgZnVuY3Rpb25zIGZyb20g
UERUXG4iLCBmZC5mdW5jdGlvbk51bWJlcik7CiAgICAgICAgICAgIGJyZWFrOwogICAgICAgIH0K
CiAgICAgICAgKytuRmQ7CgogICAgICAgIHN3aXRjaCAoZmQuZnVuY3Rpb25OdW1iZXIpIHsKICAg
ICAgICAgICAgY2FzZSAweDM0OgogICAgICAgICAgICAgICAgZmRfMzQucXVlcnlCYXNlID0gZmQu
cXVlcnlCYXNlOwogICAgICAgICAgICAgICAgZmRfMzQuZGF0YUJhc2UgPSBmZC5kYXRhQmFzZTsK
ICAgICAgICAgICAgICAgIGZkXzM0LmNvbnRyb2xCYXNlID0gZmQuY29udHJvbEJhc2U7CiAgICAg
ICAgICAgIGJyZWFrOwogICAgICAgICAgICBjYXNlIDB4MDE6IC8qIEludGVycnVwdCAqLwogICAg
ICAgICAgICAgICAgdHMtPmYwMS5kYXRhX29mZnNldCA9IGZkLmRhdGFCYXNlOwogICAgICAgICAg
ICAgICAgZmRfMDEucXVlcnlCYXNlID0gZmQucXVlcnlCYXNlOwogICAgICAgICAgICAgICAgZmRf
MDEuZGF0YUJhc2UgPSBmZC5kYXRhQmFzZTsKICAgICAgICAgICAgICAgIGZkXzAxLmNvbW1hbmRC
YXNlID0gZmQuY29tbWFuZEJhc2U7CiAgICAgICAgICAgICAgICBmZF8wMS5jb250cm9sQmFzZSA9
IGZkLmNvbnRyb2xCYXNlOwogICAgICAgICAgICAgICAgLyoKICAgICAgICAgICAgICAgICAqIENh
bid0IGRldGVybWluZSBkYXRhX2xlbmd0aAogICAgICAgICAgICAgICAgICogdW50aWwgd2hvbGUg
UERUIGhhcyBiZWVuIHJlYWQgdG8gY291bnQgaW50ZXJydXB0IHNvdXJjZXMKICAgICAgICAgICAg
ICAgICAqIGFuZCBjYWxjdWxhdGUgbnVtYmVyIG9mIGludGVycnVwdCBzdGF0dXMgcmVnaXN0ZXJz
LgogICAgICAgICAgICAgICAgICogU2V0dGluZyB0byAwIHNhZmVseSAiaWdub3JlcyIgZm9yIG5v
dy4KICAgICAgICAgICAgICAgICAqLwogICAgICAgICAgICAgICAgZGF0YV9sZW5ndGggPSAwOwog
ICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgY2FzZSAweDExOiAvKiAyRCAqLwogICAgICAg
ICAgICAgICAgdHMtPmhhc0YxMSA9IHRydWU7CiAgICAgICAgICAgICAgICB0cy0+ZjExLmRhdGFf
b2Zmc2V0ID0gZmQuZGF0YUJhc2U7CiAgICAgICAgICAgICAgICB0cy0+ZjExLmludGVycnVwdF9v
ZmZzZXQgPSBpbnRlcnJ1cHRDb3VudCAvIDg7CiAgICAgICAgICAgICAgICB0cy0+ZjExLmludGVy
cnVwdF9tYXNrID0gKCgxIDw8IElOVEVSUlVQVF9TT1VSQ0VfQ09VTlQoZmQuaW50U3JjKSkgLSAx
KSA8PCAoaW50ZXJydXB0Q291bnQgJSA4KTsKICAgICAgICAgICAgICAgIHJldCA9IGkyY190cmFu
c2Zlcih0cy0+Y2xpZW50LT5hZGFwdGVyLCBxdWVyeV9pMmNfbXNnLCAyKTsKICAgICAgICAgICAg
ICAgIGlmIChyZXQgPCAwKQogICAgICAgICAgICAgICAgICAgIHByaW50ayhLRVJOX0VSUiAiRXJy
b3IgcmVhZGluZyBGMTEgcXVlcnkgcmVnaXN0ZXJzXG4iKTsKCiAgICAgICAgICAgICAgICB0cy0+
ZjExLnBvaW50c19zdXBwb3J0ZWQgPSAocXVlcnlbMV0gJiA3KSArIDE7CiAgICAgICAgICAgICAg
ICBpZiAodHMtPmYxMS5wb2ludHNfc3VwcG9ydGVkID09IDYpCiAgICAgICAgICAgICAgICAgICAg
dHMtPmYxMS5wb2ludHNfc3VwcG9ydGVkID0gMTA7CgogICAgICAgICAgICAgICAgdHMtPmYxMV9m
aW5nZXJzID0ga2NhbGxvYyh0cy0+ZjExLnBvaW50c19zdXBwb3J0ZWQsIHNpemVvZigqdHMtPmYx
MV9maW5nZXJzKSwgMCk7CiAgICAgICAgICAgICAgICBUU19ERUJVR19STUkoIiVkIGZpbmdlcnNc
biIsIHRzLT5mMTEucG9pbnRzX3N1cHBvcnRlZCk7CgogICAgICAgICAgICAgICAgdHMtPmYxMV9o
YXNfZ2VzdHVyZXMgPSAocXVlcnlbMV0gPj4gNSkgJiAxOwogICAgICAgICAgICAgICAgdHMtPmYx
MV9oYXNfcmVsYXRpdmUgPSAocXVlcnlbMV0gPj4gMykgJiAxOwogICAgICAgICAgICAgICAgLyog
PCBEVFMyMDEwMDkwNjAzNTM4IHpoYW5ndGFvIDIwMTAwOTEzIGJlZ2luICovCiAgICAgICAgICAg
ICAgICAvKiBpZiB0aGUgc2Vuc2l0aXZpdHkgYWRqdXN0IGV4aXN0ICovCiAgICAgICAgICAgICAg
ICB0cy0+ZjExX2hhc19TZW5zaXRpdml0eV9BZGp1c3QgPSAocXVlcnlbMV0gPj4gNikgJiAxOwog
ICAgICAgICAgICAgICAgLyogRFRTMjAxMDA5MDYwMzUzOCB6aGFuZ3RhbyAyMDEwMDkxMyBlbmQg
PiAqLwogICAgICAgICAgICAgICAgZWdyID0gJnF1ZXJ5WzddOwoKICAgICAgICAgICAgICAgIFRT
X0RFQlVHX1JNSSgiRUdSIGZlYXR1cmVzOlxuIik7CiAgICAgICAgICAgICAgICB0cy0+aGFzRWdy
UGluY2ggPSBlZ3JbRUdSX1BJTkNIX1JFR10gJiBFR1JfUElOQ0g7CiAgICAgICAgICAgICAgICBU
U19ERUJVR19STUkoIlx0cGluY2g6ICV1XG4iLCB0cy0+aGFzRWdyUGluY2gpOwogICAgICAgICAg
ICAgICAgdHMtPmhhc0VnclByZXNzID0gZWdyW0VHUl9QUkVTU19SRUddICYgRUdSX1BSRVNTOwog
ICAgICAgICAgICAgICAgVFNfREVCVUdfUk1JKCJcdHByZXNzOiAldVxuIiwgdHMtPmhhc0VnclBy
ZXNzKTsKICAgICAgICAgICAgICAgIHRzLT5oYXNFZ3JGbGljayA9IGVncltFR1JfRkxJQ0tfUkVH
XSAmIEVHUl9GTElDSzsKICAgICAgICAgICAgICAgIFRTX0RFQlVHX1JNSSgiXHRmbGljazogJXVc
biIsIHRzLT5oYXNFZ3JGbGljayk7CiAgICAgICAgICAgICAgICB0cy0+aGFzRWdyRWFybHlUYXAg
PSBlZ3JbRUdSX0VBUkxZX1RBUF9SRUddICYgRUdSX0VBUkxZX1RBUDsKICAgICAgICAgICAgICAg
IFRTX0RFQlVHX1JNSSgiXHRlYXJseSB0YXA6ICV1XG4iLCB0cy0+aGFzRWdyRWFybHlUYXApOwog
ICAgICAgICAgICAgICAgdHMtPmhhc0VnckRvdWJsZVRhcCA9IGVncltFR1JfRE9VQkxFX1RBUF9S
RUddICYgRUdSX0RPVUJMRV9UQVA7CiAgICAgICAgICAgICAgICBUU19ERUJVR19STUkoIlx0ZG91
YmxlIHRhcDogJXVcbiIsIHRzLT5oYXNFZ3JEb3VibGVUYXApOwogICAgICAgICAgICAgICAgdHMt
Pmhhc0VnclRhcEFuZEhvbGQgPSBlZ3JbRUdSX1RBUF9BTkRfSE9MRF9SRUddICYgRUdSX1RBUF9B
TkRfSE9MRDsKICAgICAgICAgICAgICAgIFRTX0RFQlVHX1JNSSgiXHR0YXAgYW5kIGhvbGQ6ICV1
XG4iLCB0cy0+aGFzRWdyVGFwQW5kSG9sZCk7CiAgICAgICAgICAgICAgICB0cy0+aGFzRWdyU2lu
Z2xlVGFwID0gZWdyW0VHUl9TSU5HTEVfVEFQX1JFR10gJiBFR1JfU0lOR0xFX1RBUDsKICAgICAg
ICAgICAgICAgIFRTX0RFQlVHX1JNSSgiXHRzaW5nbGUgdGFwOiAldVxuIiwgdHMtPmhhc0VnclNp
bmdsZVRhcCk7CiAgICAgICAgICAgICAgICB0cy0+aGFzRWdyUGFsbURldGVjdCA9IGVncltFR1Jf
UEFMTV9ERVRFQ1RfUkVHXSAmIEVHUl9QQUxNX0RFVEVDVDsKICAgICAgICAgICAgICAgIFRTX0RF
QlVHX1JNSSgiXHRwYWxtIGRldGVjdDogJXVcbiIsIHRzLT5oYXNFZ3JQYWxtRGV0ZWN0KTsKCiAg
ICAgICAgICAgICAgICBxdWVyeV9pMmNfbXNnWzBdLmJ1ZiA9ICZmZC5jb250cm9sQmFzZTsKICAg
ICAgICAgICAgICAgIHJldCA9IGkyY190cmFuc2Zlcih0cy0+Y2xpZW50LT5hZGFwdGVyLCBxdWVy
eV9pMmNfbXNnLCAyKTsKCgkJaWYgKHJldCA8IDApCiAgICAgICAgICAgICAgICAgICAgcHJpbnRr
KEtFUk5fRVJSICJFcnJvciByZWFkaW5nIEYxMSBjb250cm9sIHJlZ2lzdGVyc1xuIik7CgogICAg
ICAgICAgICAgICAgcXVlcnlfaTJjX21zZ1swXS5idWYgPSAmZmQucXVlcnlCYXNlOwoKICAgICAg
ICAgICAgICAgIHRzLT5mMTFfbWF4X3ggPSAoKHF1ZXJ5WzddICYgMHgwZikgKiAweDEwMCkgfCBx
dWVyeVs2XTsKICAgICAgICAgICAgICAgIHRzLT5mMTFfbWF4X3kgPSAoKHF1ZXJ5WzldICYgMHgw
ZikgKiAweDEwMCkgfCBxdWVyeVs4XTsKCiAgICAgICAgICAgICAgICBUU19ERUJVR19STUkoIm1h
eCBYOiAlZDsgbWF4IFk6ICVkXG4iLCB0cy0+ZjExX21heF94LCB0cy0+ZjExX21heF95KTsKCiAg
ICAgICAgICAgICAgICB0cy0+ZjExLmRhdGFfbGVuZ3RoID0gZGF0YV9sZW5ndGggPQogICAgICAg
ICAgICAgICAgLyogZmluZ2VyIHN0YXR1cywgZm91ciBmaW5nZXJzIHBlciByZWdpc3RlciAqLwog
ICAgICAgICAgICAgICAgKCh0cy0+ZjExLnBvaW50c19zdXBwb3J0ZWQgKyAzKSAvIDQpCiAgICAg
ICAgICAgICAgICAvKiBhYnNvbHV0ZSBkYXRhLCA1IHBlciBmaW5nZXIgKi8KICAgICAgICAgICAg
ICAgICsgNSAqIHRzLT5mMTEucG9pbnRzX3N1cHBvcnRlZAogICAgICAgICAgICAgICAgLyogdHdv
IHJlbGF0aXZlIHJlZ2lzdGVycyAqLwogICAgICAgICAgICAgICAgKyAodHMtPmYxMV9oYXNfcmVs
YXRpdmUgPyAyIDogMCkKICAgICAgICAgICAgICAgIC8qIEYxMV8yRF9EYXRhOCBpcyBvbmx5IHBy
ZXNlbnQgaWYgdGhlIGVncl8wIHJlZ2lzdGVyIGlzIG5vbi16ZXJvLiAqLwogICAgICAgICAgICAg
ICAgKyAoZWdyWzBdID8gMSA6IDApCiAgICAgICAgICAgICAgICAvKiBGMTFfMkRfRGF0YTkgaXMg
b25seSBwcmVzZW50IGlmIGVpdGhlciBlZ3JfMCBvciBlZ3JfMSByZWdpc3RlcnMgYXJlIG5vbi16
ZXJvLiAqLwogICAgICAgICAgICAgICAgKyAoKGVnclswXSB8fCBlZ3JbMV0pID8gMSA6IDApCiAg
ICAgICAgICAgICAgICAvKiBGMTFfMkRfRGF0YTEwIGlzIG9ubHkgcHJlc2VudCBpZiBFR1JfUElO
Q0ggb3IgRUdSX0ZMSUNLIG9mIGVncl8wIHJlcG9ydHMgYXMgMS4gKi8KICAgICAgICAgICAgICAg
ICsgKCh0cy0+aGFzRWdyUGluY2ggfHwgdHMtPmhhc0VnckZsaWNrKSA/IDEgOiAwKQogICAgICAg
ICAgICAgICAgLyogRjExXzJEX0RhdGExMSBhbmQgRjExXzJEX0RhdGExMiBhcmUgb25seSBwcmVz
ZW50IGlmIEVHUl9GTElDSyBvZiBlZ3JfMCByZXBvcnRzIGFzIDEuICovCiAgICAgICAgICAgICAg
ICArICh0cy0+aGFzRWdyRmxpY2sgPyAyIDogMCk7CiAgICAgICAgICAgIGJyZWFrOwogICAgICAg
ICAgICBjYXNlIDB4MzA6IC8qIEdQSU8gKi8KICAgICAgICAgICAgICAgIHRzLT5oYXNGMzAgPSB0
cnVlOwogICAgICAgICAgICAgICAgdHMtPmYzMC5kYXRhX29mZnNldCA9IGZkLmRhdGFCYXNlOwog
ICAgICAgICAgICAgICAgdHMtPmYzMC5pbnRlcnJ1cHRfb2Zmc2V0ID0gaW50ZXJydXB0Q291bnQg
LyA4OwogICAgICAgICAgICAgICAgdHMtPmYzMC5pbnRlcnJ1cHRfbWFzayA9ICgoMSA8IElOVEVS
UlVQVF9TT1VSQ0VfQ09VTlQoZmQuaW50U3JjKSkgLSAxKSA8PCAoaW50ZXJydXB0Q291bnQgJSA4
KTsKCiAgICAgICAgICAgICAgICByZXQgPSBpMmNfdHJhbnNmZXIodHMtPmNsaWVudC0+YWRhcHRl
ciwgcXVlcnlfaTJjX21zZywgMik7CgogICAgICAgICAgICAgICAgaWYgKHJldCA8IDApCiAgICAg
ICAgICAgICAgICAgICAgcHJpbnRrKEtFUk5fRVJSICJFcnJvciByZWFkaW5nIEYzMCBxdWVyeSBy
ZWdpc3RlcnNcbiIpOwoKICAgICAgICAgICAgICAgIHRzLT5mMzAucG9pbnRzX3N1cHBvcnRlZCA9
IHF1ZXJ5WzFdICYgMHgxRjsKICAgICAgICAgICAgICAgIHRzLT5mMzAuZGF0YV9sZW5ndGggPSBk
YXRhX2xlbmd0aCA9ICh0cy0+ZjMwLnBvaW50c19zdXBwb3J0ZWQgKyA3KSAvIDg7CiAgICAgICAg
ICAgIGJyZWFrOwogICAgICAgICAgICBkZWZhdWx0OgogICAgICAgICAgICAgICAgZ290byBwZHRf
bmV4dF9pdGVyOwogICAgICAgIH0gLyogZW5kIHN3aXRoICovCgogICAgICAgIC8qIENoYW5nZSB0
byBlbmQgYWRkcmVzcyBmb3IgY29tcGFyaXNvbiBOT1RFOiBtYWtlIHN1cmUgZmluYWwgdmFsdWUg
b2YgdHMtPmRhdGFfcmVnIGlzIHN1YnRyYWN0ZWQgKi8KICAgICAgICBkYXRhX2xlbmd0aCArPSBm
ZC5kYXRhQmFzZTsKCiAgICAgICAgaWYgKGRhdGFfbGVuZ3RoID4gdHMtPmRhdGFfbGVuZ3RoKSB7
CiAgICAgICAgICAgIHRzLT5kYXRhX2xlbmd0aCA9IGRhdGFfbGVuZ3RoOwogICAgICAgIH0KCiAg
ICAgICAgaWYgKGZkLmRhdGFCYXNlIDwgdHMtPmRhdGFfcmVnKSB7CiAgICAgICAgICAgIHRzLT5k
YXRhX3JlZyA9IGZkLmRhdGFCYXNlOwogICAgICAgIH0KCiAgICAgICAgcGR0X25leHRfaXRlcjoK
ICAgICAgICBpbnRlcnJ1cHRDb3VudCArPSBJTlRFUlJVUFRfU09VUkNFX0NPVU5UKGZkLmludFNy
Yyk7CiAgICB9IC8qIGVuZCBmb3IgKi8KCiAgICAvKiBOb3cgdGhhdCBQRFQgaGFzIGJlZW4gcmVh
ZCwgaW50ZXJydXB0IGNvdW50IGRldGVybWluZWQsIEYwMSBkYXRhIGxlbmd0aCBjYW4gYmUgZGV0
ZXJtaW5lZC4qLwogICAgdHMtPmYwMS5kYXRhX2xlbmd0aCA9IGRhdGFfbGVuZ3RoID0gMSArICgo
aW50ZXJydXB0Q291bnQgKyA3KSAvIDgpOwogICAgLyogQ2hhbmdlIHRvIGVuZCBhZGRyZXNzIGZv
ciBjb21wYXJpc29uCiAgICBOT1RFOiBtYWtlIHN1cmUgZmluYWwgdmFsdWUgb2YgdHMtPmRhdGFf
cmVnIGlzIHN1YnRyYWN0ZWQqLwogICAgZGF0YV9sZW5ndGggKz0gdHMtPmYwMS5kYXRhX29mZnNl
dDsKCiAgICBpZiAoZGF0YV9sZW5ndGggPiB0cy0+ZGF0YV9sZW5ndGgpIHsKICAgICAgICB0cy0+
ZGF0YV9sZW5ndGggPSBkYXRhX2xlbmd0aDsKICAgIH0KCiAgICAvKkNoYW5nZSBkYXRhX2xlbmd0
aCBiYWNrIGZyb20gZW5kIGFkZHJlc3MgdG8gbGVuZ3RoKi8KICAgIC8qTk9URTogbWFrZSBzdXJl
IHRoaXMgd2FzIGFuIGFkZHJlc3MqLwogICAgdHMtPmRhdGFfbGVuZ3RoIC09IHRzLT5kYXRhX3Jl
ZzsKCiAgICAvLyBJIHdhbnQgdG8gcmVhZCB0aGUgcmVnaXN0ZXIgZnJvbSBGMDFfZGF0YV9yZWcK
ICAgIHRzLT5kYXRhX3JlZyA9IHRzLT5mMDEuZGF0YV9vZmZzZXQ7IAogICAgdHMtPmRhdGFfbGVu
Z3RoID0gKHRzLT5mMDEuZGF0YV9sZW5ndGgpICsgKHRzLT5mMTEuZGF0YV9sZW5ndGgpOwoKICAg
IHRzLT5mMDEuZGF0YV9vZmZzZXQgLT0gdHMtPmRhdGFfcmVnOwogICAgdHMtPmYxMS5kYXRhX29m
ZnNldCAtPSB0cy0+ZGF0YV9yZWc7CiAgICB0cy0+ZjE5LmRhdGFfb2Zmc2V0IC09IHRzLT5kYXRh
X3JlZzsKICAgIHRzLT5mMzAuZGF0YV9vZmZzZXQgLT0gdHMtPmRhdGFfcmVnOwoKICAgIHRzLT5k
YXRhID0ga2NhbGxvYyh0cy0+ZGF0YV9sZW5ndGgsIHNpemVvZigqdHMtPmRhdGEpLCAwKTsKCiAg
ICBpZiAodHMtPmRhdGEgPT0gTlVMTCkgewogICAgICAgIHByaW50ayhLRVJOX0VSUiAiTm90IGVu
b3VnaCBtZW1vcnkgdG8gYWxsb2NhdGUgc3BhY2UgZm9yIFJNSTQgZGF0YVxuIik7CiAgICAgICAg
cmV0ID0gLUVOT01FTTsKICAgIH0KCiAgICB0cy0+ZGF0YV9pMmNfbXNnWzBdLmFkZHIgPSB0cy0+
Y2xpZW50LT5hZGRyOwogICAgdHMtPmRhdGFfaTJjX21zZ1swXS5mbGFncyA9IDA7CiAgICB0cy0+
ZGF0YV9pMmNfbXNnWzBdLmxlbiA9IDE7CiAgICB0cy0+ZGF0YV9pMmNfbXNnWzBdLmJ1ZiA9ICZ0
cy0+ZGF0YV9yZWc7CgogICAgdHMtPmRhdGFfaTJjX21zZ1sxXS5hZGRyID0gdHMtPmNsaWVudC0+
YWRkcjsKICAgIHRzLT5kYXRhX2kyY19tc2dbMV0uZmxhZ3MgPSBJMkNfTV9SRDsKICAgIHRzLT5k
YXRhX2kyY19tc2dbMV0ubGVuID0gdHMtPmRhdGFfbGVuZ3RoOwogICAgdHMtPmRhdGFfaTJjX21z
Z1sxXS5idWYgPSB0cy0+ZGF0YTsKCiAgICBwcmludGsoS0VSTl9FUlIgIlJNSTQgJCUwMlggZGF0
YSByZWFkOiAkJTAyWCArICVkXG4iLCB0cy0+Y2xpZW50LT5hZGRyLCB0cy0+ZGF0YV9yZWcsIHRz
LT5kYXRhX2xlbmd0aCk7CiAgICByZXR1cm4gcmV0Owp9CgoKc3RhdGljIHZvaWQgc3luYXB0aWNz
X3JtaTRfd29ya19mdW5jKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKewoJaW50IHJldDsKICAg
IF9fdTggZmluZ2VyX3N0YXR1cyA9IDB4MDA7CiAgICAKCiAgICBfX3U4IHJlZyA9IDA7CiAgICBf
X3U4ICpmaW5nZXJfcmVnID0gTlVMTDsKICAgIHUxMiB4ID0gMDsKICAgIHUxMiB5ID0gMDsKICAg
IHU0IHd4ID0gMDsKICAgIHU0IHd5ID0gMDsKICAgIHU4IHogPSAwIDsKCV9fdTggcHJldl9zdGF0
ZSA9IDA7Cgl1OCBmaW5nZXJfcHJlc3NlZF9jb3VudCA9IDA7CgoJc3RydWN0IHN5bmFwdGljc19y
bWk0ICp0cyA9IGNvbnRhaW5lcl9vZih3b3JrLAoJCQkJCXN0cnVjdCBzeW5hcHRpY3Nfcm1pNCwg
d29yayk7CgoJcmV0ID0gaTJjX3RyYW5zZmVyKHRzLT5jbGllbnQtPmFkYXB0ZXIsIHRzLT5kYXRh
X2kyY19tc2csIDIpOwoKCWlmIChyZXQgPCAwKSB7CgkJcHJpbnRrKEtFUk5fRVJSICIlczogaTJj
X3RyYW5zZmVyIGZhaWxlZFxuIiwgX19mdW5jX18pOwoJfQogICAgZWxzZSAvKiBlbHNlIHdpdGgg
ImkyY190cmFuc2ZlcidzIHJldHVybiB2YWx1ZSIqLwoJewoJCV9fdTggKmludGVycnVwdCA9ICZ0
cy0+ZGF0YVt0cy0+ZjAxLmRhdGFfb2Zmc2V0ICsgMV07CgkJaWYgKHRzLT5oYXNGMTEgJiYgaW50
ZXJydXB0W3RzLT5mMTEuaW50ZXJydXB0X29mZnNldF0gJiB0cy0+ZjExLmludGVycnVwdF9tYXNr
KSAKICAgICAgICB7CiAgICAgICAgICAgIF9fdTggKmYxMV9kYXRhID0gJnRzLT5kYXRhW3RzLT5m
MTEuZGF0YV9vZmZzZXRdOwoKICAgICAgICAgICAgaW50IGYgPSAwOwoJCQlfX3U4IGZpbmdlcl9z
dGF0dXNfcmVnID0gMDsKCQkJX191OCBmc3JfbGVuID0gKHRzLT5mMTEucG9pbnRzX3N1cHBvcnRl
ZCArIDMpIC8gNDsKICAgICAgICAgICAgVFNfREVCVUdfUk1JKCJmMTEucG9pbnRzX3N1cHBvcnRl
ZCBpcyAlZFxuIix0cy0+ZjExLnBvaW50c19zdXBwb3J0ZWQpOwogICAgICAgICAgICBpZih0cy0+
aXNfc3VwcG9ydF9tdWx0aV90b3VjaCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgZm9y
IChmID0gMDsgZiA8IHBvaW50X3N1cHBvcnRlZF9odWF3ZWk7ICsrZikKICAgICAgICAgICAgICAg
IHsKCiAgICAgICAgICAgICAgICAJaWYgKCEoZiAlIDQpKQogICAgICAgICAgICAgICAgICAgICAg
ICAKICAgICAgICAgICAgICAgIAlmaW5nZXJfc3RhdHVzX3JlZyA9IGYxMV9kYXRhW2YgLyA0XTsK
CiAgICAgICAgICAgICAgICAJZmluZ2VyX3N0YXR1cyA9IChmaW5nZXJfc3RhdHVzX3JlZyA+PiAo
KGYgJSA0KSAqIDIpKSAmIDM7CgogICAgICAgICAgICAgICAgCXJlZyA9IGZzcl9sZW4gKyA1ICog
ZjsKICAgICAgICAgICAgICAgIAlmaW5nZXJfcmVnID0gJmYxMV9kYXRhW3JlZ107CgogICAgICAg
ICAgICAgICAgCXggPSAoZmluZ2VyX3JlZ1swXSAqIDB4MTApIHwgKGZpbmdlcl9yZWdbMl0gJSAw
eDEwKTsKICAgICAgICAgICAgICAgIAl5ID0gKGZpbmdlcl9yZWdbMV0gKiAweDEwKSB8IChmaW5n
ZXJfcmVnWzJdIC8gMHgxMCk7CiAgICAgICAgICAgICAgICAJd3ggPSBmaW5nZXJfcmVnWzNdICUg
MHgxMDsKICAgICAgICAgICAgICAgIAl3eSA9IGZpbmdlcl9yZWdbM10gLyAweDEwOwogICAgICAg
ICAgICAgICAgCXogPSBmaW5nZXJfcmVnWzRdOwogICAgICAgICAgICAgICAgICAgIC8qIHdoZW4g
dGhlIGVzZCBpcyBnZXQgZXJyb3Igd2UgcmVzZXQgdGhlIHRvdWNoc2NyZWVuIGljKG9ubHkgb24g
dTg4MjAgbm93KSAqLwoKICAgICAgICAgICAgICAgICAgICBpZihtYWNoaW5lX2lzX21zbTd4MzBf
dTg4MjAoKSkKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIGlm
KGludGVycnVwdFt0cy0+ZjExLmludGVycnVwdF9vZmZzZXRdICYgMHgwMikKICAgICAgICAgICAg
ICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gaTJjX3NtYnVz
X3JlYWRfYnl0ZV9kYXRhKHRzLT5jbGllbnQsIGZkXzAxLmRhdGFCYXNlKTsKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGlmKHJldCAmIDB4MDMpCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcmV0ID0gaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YSh0cy0+Y2xpZW50LCBm
ZF8wMS5jb21tYW5kQmFzZSwgMHgwMSk7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
cHJpbnRrKCJ0aGUgdG91Y2hzY3JlZW4gaXMgcmVzZXQgeWV0IVxuIik7CiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAg
ICAgICB9CiAgICAgICAgICAgICAgICAgICAgeCA9IHggKiBsY2RfeCAvIHRzX3hfbWF4OwoJCQkJ
CWlmIChtYWNoaW5lX2lzX21zbTd4MjdhX1U4NjYxKCkpCiAgICAgICAgICAgICAgICAgICAgewog
ICAgICAgICAgICAgICAgICAgICAgICB5ID0gKCh0c195X21heCAtIHkpICogbGNkX2FsbCApIC8g
dHNfeV9tYXg7CiAgICAgICAgICAgICAgICAgICAJfQogICAgICAgICAgICAgICAgICAgIGVsc2UK
ICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgIHkgPSAoIHkgKiBs
Y2RfYWxsICkgLyB0c195X21heDsKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICAgICAgeCA9IGNoZWNrX3Njb3BlX1goeCk7CgogICAgICAgICAgICAgICAgICAgIERCR19NQVNL
KCJ0aGUgeCBpcyAlZCB0aGUgeSBpcyAlZCB0aGUgc3RhdXRzIGlzICVkIVxuIix4LHksZmluZ2Vy
X3N0YXR1cyk7CgkJCQkJcHJldl9zdGF0ZSA9IHRzLT5mMTFfZmluZ2Vyc1tmXS5zdGF0dXM7CgoJ
CQkJCWlmIChwcmV2X3N0YXRlICYmICFmaW5nZXJfc3RhdHVzICkgCgkJCQkJewoJCQkJCQl6ID0g
d3ggPSB3eSA9IDA7CgkJCQkJfQoJCQkJCWVsc2UgaWYgKCFwcmV2X3N0YXRlICYmICFmaW5nZXJf
c3RhdHVzICkgCgkJCQkJewoJCQkJCQljb250aW51ZTsKCQkJCQl9IAoJICAgICAgICAgICAgICAg
IGlucHV0X3JlcG9ydF9hYnModHMtPmlucHV0X2RldiwgQUJTX01UX1BSRVNTVVJFLCB6KTsKCSAg
ICAgICAgICAgICAgICBpbnB1dF9yZXBvcnRfYWJzKHRzLT5pbnB1dF9kZXYsIEFCU19NVF9UT1VD
SF9NQUpPUiwgbWF4KHd4LCB3eSkpOwoJCQkJCWlucHV0X3JlcG9ydF9hYnModHMtPmlucHV0X2Rl
diwgQUJTX01UX1RPVUNIX01JTk9SLCBtaW4od3gsIHd5KSk7CgkJCQkJaW5wdXRfcmVwb3J0X2Fi
cyh0cy0+aW5wdXRfZGV2LCBBQlNfTVRfT1JJRU5UQVRJT04sICh3eCA+IHd5ID8gMSA6IDApKTsK
CQkJCQlpbnB1dF9yZXBvcnRfYWJzKHRzLT5pbnB1dF9kZXYsIEFCU19NVF9QT1NJVElPTl9YLCB4
KTsKCSAgICAgICAgICAgICAgICBpbnB1dF9yZXBvcnRfYWJzKHRzLT5pbnB1dF9kZXYsIEFCU19N
VF9QT1NJVElPTl9ZLCB5KTsKCQkJCQlpbnB1dF9yZXBvcnRfYWJzKHRzLT5pbnB1dF9kZXYsIEFC
U19NVF9UUkFDS0lOR19JRCwgZik7CgoJICAgICAgICAgICAgICAgIGlucHV0X210X3N5bmModHMt
PmlucHV0X2Rldik7ICAKCgkgICAgICAgICAgICAgICAgdHMtPmYxMV9maW5nZXJzW2ZdLnN0YXR1
cyA9IGZpbmdlcl9zdGF0dXM7CgkJCQkJaWYgKGZpbmdlcl9zdGF0dXMgPiAwKQoJCQkJCQlmaW5n
ZXJfcHJlc3NlZF9jb3VudCsrOwogICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAg
fQoJCQkJaW5wdXRfcmVwb3J0X2tleSh0cy0+aW5wdXRfZGV2LCBCVE5fVE9VQ0gsIGZpbmdlcl9w
cmVzc2VkX2NvdW50KTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlIC8qIGVsc2Ugd2l0
aCAiaWYodHMtPmlzX3N1cHBvcnRfbXVsdGlfdG91Y2gpIiovCiAgICAgICAgICAgIHsKICAgIAkJ
CWZpbmdlcl9zdGF0dXNfcmVnID0gZjExX2RhdGFbMF07CiAgICAgICAgICAgICAgICBmaW5nZXJf
c3RhdHVzID0gKGZpbmdlcl9zdGF0dXNfcmVnICYgMyk7CiAgICAgICAgICAgICAgICBUU19ERUJV
R19STUkoInRoZSBmaW5nZXJfc3RhdHVzIGlzICUyZCFcbiIsZmluZ2VyX3N0YXR1cyk7CiAgICAg
ICAgICAKICAgICAgICAgICAgICAgIHJlZyA9IGZzcl9sZW47CiAgICAgICAgICAgICAgICBmaW5n
ZXJfcmVnID0gJmYxMV9kYXRhW3JlZ107CiAgICAgICAgICAgICAgICB4ID0gKGZpbmdlcl9yZWdb
MF0gKiAweDEwKSB8IChmaW5nZXJfcmVnWzJdICUgMHgxMCk7CiAgICAgICAgICAgICAgICB5ID0g
KGZpbmdlcl9yZWdbMV0gKiAweDEwKSB8IChmaW5nZXJfcmVnWzJdIC8gMHgxMCk7CgkJCQl3eCA9
IGZpbmdlcl9yZWdbM10gJSAweDEwOwoJCQkJd3kgPSBmaW5nZXJfcmVnWzNdIC8gMHgxMDsKCQkJ
CXogPSBmaW5nZXJfcmVnWzRdOwoKICAgICAgICAgICAgICAgIHggPSB4ICogbGNkX3ggLyB0c194
X21heDsKICAgICAgICAgICAgICAgIHkgPSB5ICogbGNkX2FsbCAvIHRzX3lfbWF4OwoJCQkJLypj
aGVjayB0aGUgc2NvcGUgb2YgWCAgYXhlcyovCiAgICAgICAgICAgICAgICB4ID0gY2hlY2tfc2Nv
cGVfWCh4KTsKCiAgICAgICAgICAgICAgICBUU19ERUJVR19STUkoS0VSTl9FUlIgInRoZSB4X3Np
ZyBpcyAlMmQgLHRoZSB5X3NpZyBpcyAlMmQgXG4iLHgsIHkpOwoKICAgICAgICAgICAgICAgIGlu
cHV0X3JlcG9ydF9hYnModHMtPmlucHV0X2RldiwgQUJTX1gsIHgpOwoJCQkJaW5wdXRfcmVwb3J0
X2Ficyh0cy0+aW5wdXRfZGV2LCBBQlNfWSwgeSk7CgoJCQkJaW5wdXRfcmVwb3J0X2Ficyh0cy0+
aW5wdXRfZGV2LCBBQlNfUFJFU1NVUkUsIHopOwogICAgICAgICAgICAgICAgaW5wdXRfcmVwb3J0
X2tleSh0cy0+aW5wdXRfZGV2LCBCVE5fVE9VQ0gsIGZpbmdlcl9zdGF0dXMpOwogICAgICAgICAg
ICAgICAgaW5wdXRfc3luYyh0cy0+aW5wdXRfZGV2KTsKICAgICAgICAgICAgCiAgICAgICAgICAg
ICAgICAKICAgICAgICAgICAgfQoKCiAKCQkJZiA9IChmICsgMykgLyA0ICsgZiAqIDU7CgkJCWlm
ICh0cy0+ZjExX2hhc19yZWxhdGl2ZSkgCiAgICAgICAgICAgIHsKCQkJCWYgKz0gMjsKCQkJfQoJ
CQlpZiAodHMtPmhhc0VnclBhbG1EZXRlY3QpIAogICAgICAgICAgICB7CiAgICAgICAgICAgICAJ
aW5wdXRfcmVwb3J0X2tleSh0cy0+aW5wdXRfZGV2LAoJICAgICAgICAgICAgICAgICBCVE5fREVB
RCwKCSAgICAgICAgICAgICAgICAgZjExX2RhdGFbZiArIEVHUl9QQUxNX0RFVEVDVF9SRUddICYg
RUdSX1BBTE1fREVURUNUKTsKCQkJfQoJCQlpZiAodHMtPmhhc0VnckZsaWNrKSAKICAgICAgICAg
ICAgewogICAgICAgICAgICAgCWlmIChmMTFfZGF0YVtmICsgRUdSX0ZMSUNLX1JFR10gJiBFR1Jf
RkxJQ0spIAogICAgICAgICAgICAgICAgewoJCQkJCWlucHV0X3JlcG9ydF9yZWwodHMtPmlucHV0
X2RldiwgUkVMX1gsIGYxMV9kYXRhW2YgKyAyXSk7CgkJCQkJaW5wdXRfcmVwb3J0X3JlbCh0cy0+
aW5wdXRfZGV2LCBSRUxfWSwgZjExX2RhdGFbZiArIDNdKTsKCQkJCX0KCQkJfQoJCQkvKmlmICh0
cy0+aGFzRWdyU2luZ2xlVGFwKSAKICAgICAgICAgICAgewoJCQkJaW5wdXRfcmVwb3J0X2tleSh0
cy0+aW5wdXRfZGV2LAoJCQkJICAgICAgICAgICAgICAgICBCVE5fVE9VQ0gsCgkJCQkgICAgICAg
ICAgICAgICAgIGYxMV9kYXRhW2YgKyBFR1JfU0lOR0xFX1RBUF9SRUddICYgRUdSX1NJTkdMRV9U
QVApOwoJCQl9Ki8KCQkJaWYgKHRzLT5oYXNFZ3JEb3VibGVUYXApIAogICAgICAgICAgICB7CgkJ
CQlpbnB1dF9yZXBvcnRfa2V5KHRzLT5pbnB1dF9kZXYsCgkJCQkgICAgICAgICAgICAgICAgIEJU
Tl9UT09MX0RPVUJMRVRBUCwKCQkJCSAgICAgICAgICAgICAgICAgZjExX2RhdGFbZiArIEVHUl9E
T1VCTEVfVEFQX1JFR10gJiBFR1JfRE9VQkxFX1RBUCk7CgkJCX0KICAgICAgICB9CgoJCWlmICh0
cy0+aGFzRjE5ICYmIGludGVycnVwdFt0cy0+ZjE5LmludGVycnVwdF9vZmZzZXRdICYgdHMtPmYx
OS5pbnRlcnJ1cHRfbWFzaykgCiAgICAgICAgewoJCQlpbnQgcmVnOwoJCQlpbnQgdG91Y2ggPSAw
OwoJCQlmb3IgKHJlZyA9IDA7IHJlZyA8ICgodHMtPmYxOS5wb2ludHNfc3VwcG9ydGVkICsgNykg
LyA4KTsgcmVnKyspCgkJCXsKCQkJCWlmICh0cy0+ZGF0YVt0cy0+ZjE5LmRhdGFfb2Zmc2V0ICsg
cmVnXSkgCiAgICAgICAgICAgICAgICB7CgkJCQkJdG91Y2ggPSAxOwoJCQkJICAgCWJyZWFrOwoJ
CQkJfQoJCQl9CgkJCWlucHV0X3JlcG9ydF9rZXkodHMtPmlucHV0X2RldiwgQlROX0RFQUQsIHRv
dWNoKTsKCgkJfQogICAgCQlpbnB1dF9zeW5jKHRzLT5pbnB1dF9kZXYpOwoJfQoJLypkZWxldGUg
b25lIGxpbmUqLwoJaWYgKHRzLT51c2VfaXJxKQoJewogICAgICAgZW5hYmxlX2lycSh0cy0+Y2xp
ZW50LT5pcnEpOwogICAgfQp9CgpzdGF0aWMgZW51bSBocnRpbWVyX3Jlc3RhcnQgc3luYXB0aWNz
X3JtaTRfdGltZXJfZnVuYyhzdHJ1Y3QgaHJ0aW1lciAqdGltZXIpCnsKCXN0cnVjdCBzeW5hcHRp
Y3Nfcm1pNCAqdHMgPSBjb250YWluZXJfb2YodGltZXIsIFwKCQkJCQlzdHJ1Y3Qgc3luYXB0aWNz
X3JtaTQsIHRpbWVyKTsKCglxdWV1ZV93b3JrKHN5bmFwdGljc193cSwgJnRzLT53b3JrKTsKCglo
cnRpbWVyX3N0YXJ0KCZ0cy0+dGltZXIsIGt0aW1lX3NldCgwLCAxMiAqIE5TRUNfUEVSX01TRUMp
LCBIUlRJTUVSX01PREVfUkVMKTsKCglyZXR1cm4gSFJUSU1FUl9OT1JFU1RBUlQ7Cn0KCmlycXJl
dHVybl90IHN5bmFwdGljc19ybWk0X2lycV9oYW5kbGVyKGludCBpcnEsIHZvaWQgKmRldl9pZCkK
ewoJc3RydWN0IHN5bmFwdGljc19ybWk0ICp0cyA9IGRldl9pZDsKCglkaXNhYmxlX2lycV9ub3N5
bmModHMtPmNsaWVudC0+aXJxKTsKCXF1ZXVlX3dvcmsoc3luYXB0aWNzX3dxLCAmdHMtPndvcmsp
OwoKCXJldHVybiBJUlFfSEFORExFRDsKfQoKc3RhdGljIHZvaWQgc3luYXB0aWNzX3JtaTRfZW5h
YmxlKHN0cnVjdCBzeW5hcHRpY3Nfcm1pNCAqdHMpCnsgIAoJaWYgKHRzLT51c2VfaXJxKQoJCWVu
YWJsZV9pcnEodHMtPmNsaWVudC0+aXJxKTsKCWVsc2UKCQlocnRpbWVyX3N0YXJ0KCZ0cy0+dGlt
ZXIsIGt0aW1lX3NldCgxLCAwKSwgSFJUSU1FUl9NT0RFX1JFTCk7CgoJdHMtPmVuYWJsZSA9IDE7
Cn0KCnN0YXRpYyB2b2lkIHN5bmFwdGljc19ybWk0X2Rpc2FibGUoc3RydWN0IHN5bmFwdGljc19y
bWk0ICp0cykKewoKCWlmICh0cy0+dXNlX2lycSkKCQlkaXNhYmxlX2lycV9ub3N5bmModHMtPmNs
aWVudC0+aXJxKTsKCWVsc2UKCQlocnRpbWVyX2NhbmNlbCgmdHMtPnRpbWVyKTsKCgljYW5jZWxf
d29ya19zeW5jKCZ0cy0+d29yayk7CgoJdHMtPmVuYWJsZSA9IDA7Cn0KCnN0YXRpYyBzc2l6ZV90
IHN5bmFwdGljc19ybWk0X2VuYWJsZV9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAq
YXR0ciwgY2hhciAqYnVmKQp7CglzdHJ1Y3Qgc3luYXB0aWNzX3JtaTQgKnRzID0gZGV2X2dldF9k
cnZkYXRhKGRldik7CgoJcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsIHRzLT5lbmFibGUpOwp9
CgpzdGF0aWMgc3NpemVfdCBzeW5hcHRpY3Nfcm1pNF9lbmFibGVfc3RvcmUoc3RydWN0IGRldmlj
ZSAqZGV2LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCnsKCXN0cnVjdCBzeW5hcHRp
Y3Nfcm1pNCAqdHMgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKCXVuc2lnbmVkIGxvbmcgdmFsOwoJ
aW50IGVycm9yOwoKCWVycm9yID0gc3RyaWN0X3N0cnRvdWwoYnVmLCAxMCwgJnZhbCk7CgoJaWYg
KGVycm9yKQoJCXJldHVybiBlcnJvcjsKCgl2YWwgPSAhIXZhbDsKCglpZiAodmFsICE9IHRzLT5l
bmFibGUpIHsKCQlpZiAodmFsKQoJCQlzeW5hcHRpY3Nfcm1pNF9lbmFibGUodHMpOwoJCWVsc2UK
CQkJc3luYXB0aWNzX3JtaTRfZGlzYWJsZSh0cyk7Cgl9CgoJcmV0dXJuIGNvdW50Owp9CgpERVZf
QVRUUihzeW5hcHRpY3Nfcm1pNCwgZW5hYmxlLCAwNjY0KTsKc3RhdGljIGNoYXIgKiBnZXRfdG91
Y2hfbW9kdWxlX25hbWUodTggbW9kdWxlX2lkKQp7Cglzd2l0Y2gobW9kdWxlX2lkKQoJewoJCWNh
c2UgQllEOgoJCQlyZXR1cm4gIkJZRCI7CgkJY2FzZSBDTUk6CgkJCXJldHVybiAiQ01JIjsKCQlj
YXNlIFRSVUxZOgoJCQlyZXR1cm4gIlRSVUxZIjsKCQljYXNlIFRQSzoKCQkJcmV0dXJuICJUUEsi
OwoJCWNhc2UgTEVOU09ORToKCQkJcmV0dXJuICJMRU5TT05FIjsKCQljYXNlIE9GSUxNOgoJCQly
ZXR1cm4gIk9GSUxNIjsKCQljYXNlIEVFTFk6CgkJCXJldHVybiAiRUVMWSI7CgkJY2FzZSBTVUND
RVNTOgoJCQlyZXR1cm4gIlNVQ0NFU1MiOwoJCWNhc2UgQUxQUzoKCQkJcmV0dXJuICJBTFBTIjsK
CQlkZWZhdWx0OgoJCQlyZXR1cm4gTlVMTDsKCX0KCglyZXR1cm4gTlVMTDsKfQovKiBuYW1lZCBS
dWxlCiAqIDIyMDIgMzIwMCA6IHN5YW5wdGljcy1JQy1Nb2R1bGUudmVyCiAqIGZvciBleGFtcGxl
OiBzeWFucHRpY3MtMzIwMC10cGsuMgogKgogKiAyMDAwIDIxMDAgMzAwMCA6c3lhbnB0aWNzLU1v
ZHVsZS52ZXIKICogZm9yIGV4YW1wbGU6IHN5YW5wdGljcy10cGsuMgogKi8KY2hhciAqIGdldF9z
eW5hcHRpY3NfdG91Y2hfaW5mbyh2b2lkKQp7Cgl1MzIgY29uZmlnX2lkID0gMDsKCWNoYXIgKiBt
b2R1bGVfbmFtZSA9IE5VTEw7CgkKCgltb2R1bGVfbmFtZSA9IGdldF90b3VjaF9tb2R1bGVfbmFt
ZShxdWVyeV9uYW1lWzJdKTsKCWlmIChtb2R1bGVfbmFtZSA9PSBOVUxMKQoJewoJCXJldHVybiBO
VUxMOwoJfQoJaWYgKHRvdWNoX2ljX25hbWUgPT0gMjIwMikKCXsKCQljb25maWdfaWQgPSBxdWVy
eV9uYW1lWzNdOwoJCXNwcmludGYodG91Y2hfaW5mbywic3luYXB0aWNzLTIyMDItJXMuJWQiLG1v
ZHVsZV9uYW1lLGNvbmZpZ19pZCk7CQkKCX0KCWVsc2UgaWYgKHRvdWNoX2ljX25hbWUgPT0gMzIw
MCkKCXsKCQljb25maWdfaWQgPSBxdWVyeV9uYW1lWzNdOwoJCXNwcmludGYodG91Y2hfaW5mbywi
c3luYXB0aWNzLTMyMDAtJXMuJWQiLG1vZHVsZV9uYW1lLGNvbmZpZ19pZCk7CQoJfQoJZWxzZQoJ
ewoJCWNvbmZpZ19pZCA9IHF1ZXJ5X25hbWVbM107CgkJc3ByaW50Zih0b3VjaF9pbmZvLCJzeW5h
cHRpY3MtJXMuJWQiLG1vZHVsZV9uYW1lLGNvbmZpZ19pZCk7CQoJfQoKCXJldHVybiB0b3VjaF9p
bmZvOwp9CiNpZiAwCmNoYXIgKiBnZXRfdG91Y2hfaW5mbyh2b2lkKQp7CgljaGFyICogdG91Y2hf
aW5mbyA9IE5VTEw7CgoJdG91Y2hfaW5mbyA9IGdldF9zeW5hcHRpY3NfdG91Y2hfaW5mbygpOwoJ
aWYgKHRvdWNoX2luZm8gIT0gTlVMTCkKCXsKCQlyZXR1cm4gdG91Y2hfaW5mbzsKCX0KCXJldHVy
biBOVUxMOwoJCn0KI2VuZGlmCgpzdGF0aWMgdm9pZCBnZXRfaWNfbmFtZSh2b2lkKQp7CiAgICBz
dHJ1Y3QgaTJjX21zZyBtc2dbMl07CiAgICBjaGFyIGljX25hbWVfYnVmZmVyWzJdOwogICAgaW50
IHJldDsKICAgIHU4IGFkZHIgPSBmZF8wMS5xdWVyeUJhc2UrMTc7CgogICAgbXNnWzBdLmFkZHIg
PSB0cy0+Y2xpZW50LT5hZGRyOwoJbXNnWzBdLmZsYWdzID0gMDsKCW1zZ1swXS5idWYgPSAmYWRk
cjsKCW1zZ1swXS5sZW4gPSAxOwoKCW1zZ1sxXS5hZGRyID0gdHMtPmNsaWVudC0+YWRkcjsKCW1z
Z1sxXS5mbGFncyA9IEkyQ19NX1JEOwoJbXNnWzFdLmJ1ZiA9IGljX25hbWVfYnVmZmVyOwoJbXNn
WzFdLmxlbiA9IHNpemVvZihpY19uYW1lX2J1ZmZlcik7CgogICAgcmV0ID0gaTJjX3RyYW5zZmVy
KHRzLT5jbGllbnQtPmFkYXB0ZXIsIG1zZywgMik7CglpZiAocmV0IDwgMCkKICAgIHsKCQlwcmlu
dGsoIkZhaWxlZCB0byByZWFkIElDIG5hbWUuXG4iKTsKICAgICAgICByZXR1cm47Cgl9CiAgICB0
b3VjaF9pY19uYW1lID0gaWNfbmFtZV9idWZmZXJbMV0gKiAweDEwMCArIGljX25hbWVfYnVmZmVy
WzBdOwp9CnN0YXRpYyB1OCBnZXRfbW9kdWxlX2lkKHZvaWQpCnsKCXN0cnVjdCBpMmNfbXNnIG1z
Z1syXTsKCWNoYXIgcHJvZHVjdGlkWzExXTsKCWludCByZXQgOwoJdW5zaWduZWQgbG9uZyBtb2R1
bGVfaWQgPSAwOwoJdTggcXVlcnliYXNlID0gMDsKCQoJcmV0ID0gUk1JNF9lbmFibGVfcHJvZ3Jh
bSh0cy0+Y2xpZW50KTsKICAgIGlmKCByZXQgIT0gMCkKCXsKCQlwcmludGsoIiVzOiVkOlJNSSBl
bmFibGUgcHJvZ3JhbSBlcnJvcixyZXR1cm4uLi5cbiIsX19GVU5DVElPTl9fLF9fTElORV9fKTsK
CQlnb3RvIGdldF9tb2R1bGVfaWRfZXJyb3I7Cgl9CglxdWVyeWJhc2UgPSBmZF8wMS5xdWVyeUJh
c2UgKyAxMTsKCiAgICBtc2dbMF0uYWRkciA9IHRzLT5jbGllbnQtPmFkZHI7Cgltc2dbMF0uZmxh
Z3MgPSAwOwoJbXNnWzBdLmJ1ZiA9ICZxdWVyeWJhc2U7Cgltc2dbMF0ubGVuID0gMTsKCgltc2db
MV0uYWRkciA9IHRzLT5jbGllbnQtPmFkZHI7Cgltc2dbMV0uZmxhZ3MgPSBJMkNfTV9SRDsKCW1z
Z1sxXS5idWYgPSBwcm9kdWN0aWQ7Cgltc2dbMV0ubGVuID0gMTA7CgoJcmV0ID0gaTJjX3RyYW5z
ZmVyKHRzLT5jbGllbnQtPmFkYXB0ZXIsIG1zZywgMik7CglpZiAocmV0IDwgMCkgCgl7CgkJcHJp
bnRrKEtFUk5fRVJSICIlczogaTJjX3RyYW5zZmVyIGZhaWxlZFxuIiwgX19mdW5jX18pOwogICAg
ICAgIGdvdG8gZ2V0X21vZHVsZV9pZF9lcnJvcjsKCX0KCQkKCXByb2R1Y3RpZFsxMF0gPSAnXDAn
OwoJcmV0ID0gc3RyaWN0X3N0cnRvdWwoJnByb2R1Y3RpZFs5XSwgMTAsICZtb2R1bGVfaWQpOwoJ
aWYgKHJldCkKCXsKCQlwcl9lcnIoIiVzIDogdHJhbnNmZXIgZXJyb3JcbiIsX19mdW5jX18pOwog
ICAgICAgIGdvdG8gZ2V0X21vZHVsZV9pZF9lcnJvcjsKCX0KCglSTUk0X2Rpc2FibGVfcHJvZ3Jh
bSh0cy0+Y2xpZW50KTsKCXJldHVybiAodTgpbW9kdWxlX2lkOwoKZ2V0X21vZHVsZV9pZF9lcnJv
cjoKICAgIFJNSTRfZGlzYWJsZV9wcm9ncmFtKHRzLT5jbGllbnQpOwogICAgcmV0dXJuIC0xOwp9
CgpzdGF0aWMgdTggZ2V0X2NvbmZpZ192ZXJzaW9uKHZvaWQpCnsKCXN0cnVjdCBpMmNfbXNnIG1z
Z1syXTsKCWNoYXIgY29uZmlndmVyWzVdOwoJaW50IHJldCA7Cgl1bnNpZ25lZCBsb25nIGNvbmZp
Z192ZXIgPSAwOwoJCQkJCQoJbXNnWzBdLmFkZHIgPSB0cy0+Y2xpZW50LT5hZGRyOwoJbXNnWzBd
LmZsYWdzID0gMDsKCW1zZ1swXS5idWYgPSAmZmRfMzQuY29udHJvbEJhc2U7Cgltc2dbMF0ubGVu
ID0gMTsKCgltc2dbMV0uYWRkciA9IHRzLT5jbGllbnQtPmFkZHI7Cgltc2dbMV0uZmxhZ3MgPSBJ
MkNfTV9SRDsKCW1zZ1sxXS5idWYgPSBjb25maWd2ZXI7Cgltc2dbMV0ubGVuID0gNDsKCglyZXQg
PSBpMmNfdHJhbnNmZXIodHMtPmNsaWVudC0+YWRhcHRlciwgbXNnLCAyKTsKCWlmIChyZXQgPCAw
KSAKCXsKCQlwcmludGsoS0VSTl9FUlIgIiVzOiBpMmNfdHJhbnNmZXIgZmFpbGVkXG4iLCBfX2Z1
bmNfXyk7CgkJcmV0dXJuIC0xOwoJfQoKCWNvbmZpZ3Zlcls0XSA9ICdcMCc7CglyZXQgPSBzdHJp
Y3Rfc3RydG91bChjb25maWd2ZXIsIDEwLCAmY29uZmlnX3Zlcik7CglpZiAocmV0IDwgMCkgCgl7
CgkJcHJfZXJyKCIlcyA6IHRyYW5zZmVyIGZhaWxcbiIsX19mdW5jX18pOwoJCXJldHVybiAtMTsK
CX0KCglyZXR1cm4gKHU4KWNvbmZpZ192ZXI7Cn0Kc3RhdGljIGludApwcm9jX2NhbGNfbWV0cmlj
cyhjaGFyICpwYWdlLCBjaGFyICoqc3RhcnQsIG9mZl90IG9mZiwgaW50IGNvdW50LCBpbnQgKmVv
ZiwgaW50IGxlbikKewoJaWYgKGxlbiA8PSBvZmYgKyBjb3VudCkKCQkqZW9mID0gMTsKCSpzdGFy
dCA9IHBhZ2UgKyBvZmY7CglsZW4gLT0gb2ZmOwoJaWYgKGxlbiA+IGNvdW50KQoJCWxlbiA9IGNv
dW50OwoJaWYgKGxlbiA8IDApCgkJbGVuID0gMDsKCXJldHVybiBsZW47Cn0Kc3RhdGljIHZvaWQg
dHBfcmVhZF9mbjM0X2lucHV0X25hbWUodm9pZCkKewogICAgcXVlcnlfbmFtZVswXSA9IDE7CiAg
ICBxdWVyeV9uYW1lWzFdID0gMTsKICAgIHF1ZXJ5X25hbWVbMl0gPSBnZXRfbW9kdWxlX2lkKCk7
CiAgICBxdWVyeV9uYW1lWzNdID0gZ2V0X2NvbmZpZ192ZXJzaW9uKCk7Cn0Kc3RhdGljIGludCB0
cF9yZWFkX2lucHV0X25hbWUodm9pZCkKewogICAgaW50IHJldDsKICAgIHF1ZXJ5X2kyY19tc2df
bmFtZVswXS5hZGRyID0gdHMtPmNsaWVudC0+YWRkcjsKCXF1ZXJ5X2kyY19tc2dfbmFtZVswXS5m
bGFncyA9IDA7CglxdWVyeV9pMmNfbXNnX25hbWVbMF0uYnVmID0gJmZkXzAxLnF1ZXJ5QmFzZTsK
CXF1ZXJ5X2kyY19tc2dfbmFtZVswXS5sZW4gPSAxOwoKCXF1ZXJ5X2kyY19tc2dfbmFtZVsxXS5h
ZGRyID0gdHMtPmNsaWVudC0+YWRkcjsKCXF1ZXJ5X2kyY19tc2dfbmFtZVsxXS5mbGFncyA9IEky
Q19NX1JEOwoJcXVlcnlfaTJjX21zZ19uYW1lWzFdLmJ1ZiA9IHF1ZXJ5X25hbWU7CglxdWVyeV9p
MmNfbXNnX25hbWVbMV0ubGVuID0gc2l6ZW9mKHF1ZXJ5X25hbWUpOwogICAgCiAgICByZXQgPSBp
MmNfdHJhbnNmZXIodHMtPmNsaWVudC0+YWRhcHRlciwgcXVlcnlfaTJjX21zZ19uYW1lLCAyKTsK
CWlmIChyZXQgPCAwKSB7CgkJcHJpbnRrKEtFUk5fRVJSICIlczogaTJjX3RyYW5zZmVyIGZhaWxl
ZCBhdCBhZGRyZXNzICQlMDJYIFxuIiwgX19mdW5jX18sIHRzLT5jbGllbnQtPmFkZHIpOwoJfQoJ
CiAgICByZXR1cm4gcmV0OwoKfQpzdGF0aWMgaW50IHRwX3JlYWRfcHJvYygKCWNoYXIgKnBhZ2Us
IGNoYXIgKipzdGFydCwgb2ZmX3Qgb2ZmLCBpbnQgY291bnQsIGludCAqZW9mLCB2b2lkICpkYXRh
KQp7CglpbnQgbGVuOwoJbGVuID0gc25wcmludGYocGFnZSwgUEFHRV9TSVpFLCAiVFBfVFlQRToi
CgkiJXNcbiIKCSJNYW51ZmFjdHVyZXIgSUQ6IgoJIiV4XG4iCiAgICAiIFByb2R1Y3QgUHJvcGVy
dGllczoiCgkiJXhcbiIKCSJDdXN0b21lciBGYW1pbHk6JXhcbiIKCSJGaXJtd2FyZSBSZXZpc2lv
bjoleFxuIiwKCSJzeW5hcGl0Y3MiLHF1ZXJ5X25hbWVbMF0sIHF1ZXJ5X25hbWVbMV0sIHF1ZXJ5
X25hbWVbMl0sIHF1ZXJ5X25hbWVbM10pOwoKICAgIHJldHVybiBwcm9jX2NhbGNfbWV0cmljcyhw
YWdlLCBzdGFydCwgb2ZmLCBjb3VudCwgZW9mLCBsZW4pOwogICAgCn0KCnN0YXRpYyBpbnQgc3lu
YXB0aWNzX3JtaTRfcHJvYmUoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwgY29uc3Qgc3RydWN0
IGkyY19kZXZpY2VfaWQgKmlkKSAKewogICAgaW50IGkgOwogICAgaW50IHJldCA9IDA7CgogICAg
c3RydWN0IHByb2NfZGlyX2VudHJ5ICpkX2VudHJ5OwogICAgc3RydWN0IHRvdWNoX2h3X3BsYXRm
b3JtX2RhdGEgKnRvdWNoX3BkYXRhID0gTlVMTDsKICAgIHN0cnVjdCB0cF9yZXNvbHV0aW9uX2Nv
bnZlcnNpb24gdHBfdHlwZV9zZWxmX2NoZWNrID0gezB9OwoKICAgIHByaW50aygiKioqKioqKioq
KioqKioqIHN5bmFwdGljc19ybWk0X3Byb2JlICoqKioqKioqKioqKioqKioqKlxuIik7CiAgICBw
cmludGsoIkNsaWVudCBhZHJlc3MgaXM6ICUwMlgiLCBjbGllbnQtPmFkZHIpOwoKICAgIGlmICgh
aTJjX2NoZWNrX2Z1bmN0aW9uYWxpdHkoY2xpZW50LT5hZGFwdGVyLCBJMkNfRlVOQ19JMkMpKXsK
CQlwcmludGsoS0VSTl9FUlIgIiVzOiBuZWVkIEkyQ19GVU5DX0kyQ1xuIiwgX19mdW5jX18pOwoJ
CXJldCA9IC1FTk9ERVY7CgkJZ290byBlcnJfY2hlY2tfZnVuY3Rpb25hbGl0eV9mYWlsZWQ7CiAg
ICB9CgogICAgVFNfREVCVUdfUk1JKCJ0aGUgaTJjX2NoZWNrX2Z1bmN0aW9uYWxpdHkgaXMgb2sg
XG4iKTsKICAgIHRvdWNoX3BkYXRhID0gY2xpZW50LT5kZXYucGxhdGZvcm1fZGF0YTsKCiAgICBp
ZihOVUxMID09IHRvdWNoX3BkYXRhKSB7CiAgICAgICAgcHJpbnRrKCJ0aGUgdG91Y2hfcGRhdGEg
aXMgTlVMTCBwbGVhc2UgY2hlY2sgdGhlIGluaXQgY29kZSAhXG4iKTsKICAgICAgICByZXQgPSAt
RU5PTUVNOwogICAgICAgIGdvdG8gZXJyX3BsYXRmb3JtX2RhdGFfaW5pdF9mYWlsZWQ7CiAgICB9
CgogICAgaWYodG91Y2hfcGRhdGEtPnJlYWRfdG91Y2hfcHJvYmVfZmxhZykgewogICAgICAgIHJl
dCA9IHRvdWNoX3BkYXRhLT5yZWFkX3RvdWNoX3Byb2JlX2ZsYWcoKTsKICAgIH0KCiAgICBpZihy
ZXQpewogICAgICAgIHByaW50ayhLRVJOX0VSUiAiJXM6IHRoZSB0b3VjaCBkcml2ZXIgaGFzIGRl
dGVjdGVkIDopIFxuIiwgX19mdW5jX18pOwogICAgICAgIHJldHVybiAtMTsKICAgIH0gZWxzZSB7
CiAgICAgICAgcHJpbnRrKEtFUk5fRVJSICIlczogaXQncyB0aGUgZmlyc3QgdG91Y2ggZHJpdmVy
ISBcbiIsIF9fZnVuY19fKTsKICAgIH0KCiAgICBpZih0b3VjaF9wZGF0YS0+dG91Y2hfcG93ZXIp
ewogICAgICAgIHJldCA9IHRvdWNoX3BkYXRhLT50b3VjaF9wb3dlcigxKTsKICAgIH0KCiAgICBp
ZihyZXQpewogICAgICAgIHByaW50ayhLRVJOX0VSUiAiJXM6IHBvd2VyIG9uIGZhaWxlZCBcbiIs
IF9fZnVuY19fKTsKICAgICAgICByZXQgPSAtRU5PTUVNOwogICAgICAgIHByaW50ayhLRVJOX0VS
UiAiMTExMTExMTExIik7CiAgICAgICAgZ290byBlcnJfcG93ZXJfb25fZmFpbGVkOwogICAgfQog
ICAgCiAgICAvKm1vdmUgdG91Y2hfcmVzZXQgZnVuY3Rpb24gZnJvbSBpbiBnZXRfcGhvbmVfdmVy
c2lvbiBmdW5jdGlvbiB0byBvdXRzaWRlICovCiAgICBpZiAodG91Y2hfcGRhdGEtPnRvdWNoX3Jl
c2V0KCkpewogICAgICAgIHJldCA9IHRvdWNoX3BkYXRhLT50b3VjaF9yZXNldCgpOwogICAgICAg
IGlmIChyZXQpewogICAgICAgICAgICBwcmludGsoS0VSTl9FUlIgIiVzOiByZXNldCBmYWlsZWQg
XG4iLCBfX2Z1bmNfXyk7CiAgICAgICAgICAgIHByaW50ayhLRVJOX0VSUiAiMjIyMjIyMjIyMjIi
KTsKICAgICAgICAgICAgZ290byBlcnJfcG93ZXJfb25fZmFpbGVkOwogICAgICAgIH0KICAgIH0K
CiAgICBpZih0b3VjaF9wZGF0YS0+Z2V0X3Bob25lX3ZlcnNpb24pewogICAgICAgIHJldCA9IHRv
dWNoX3BkYXRhLT5nZXRfcGhvbmVfdmVyc2lvbigmdHBfdHlwZV9zZWxmX2NoZWNrKTsKICAgICAg
ICBpZihyZXQgPCAwKXsKICAgICAgICAgICAgcHJpbnRrKEtFUk5fRVJSICIlczogcmVzZXQgZmFp
bGVkIFxuIiwgX19mdW5jX18pOwogICAgICAgICAgICBwcmludGsoS0VSTl9FUlIgIjMzMzMzMzMz
MzMzIik7CiAgICAgICAgICAgIGdvdG8gZXJyX3Bvd2VyX29uX2ZhaWxlZDsKICAgICAgICB9IGVs
c2UgewogICAgICAgICAgICBsY2RfeCA9IHRwX3R5cGVfc2VsZl9jaGVjay5sY2RfeDsKICAgICAg
ICAgICAgbGNkX3kgPSB0cF90eXBlX3NlbGZfY2hlY2subGNkX3k7CiAgICAgICAgICAgIGxjZF9h
bGwgPSB0cF90eXBlX3NlbGZfY2hlY2subGNkX2FsbDsKICAgICAgICB9CiAgICB9CgogICAgdHMg
PSBremFsbG9jKHNpemVvZigqdHMpLCBHRlBfS0VSTkVMKTsKICAgIGlmICh0cyA9PSBOVUxMKXsK
ICAgICAgICBwcmludGsoS0VSTl9FUlIgIiVzOiBjaGVjayB6YWxsb2MgZmFpbGVkIVxuIiwgX19m
dW5jX18pOwogICAgICAgIHJldCA9IC1FTk9NRU07CiAgICAgICAgZ290byBlcnJfYWxsb2NfZGF0
YV9mYWlsZWQ7CiAgICB9CgogICAgc3luYXB0aWNzX3dxID0gY3JlYXRlX3NpbmdsZXRocmVhZF93
b3JrcXVldWUoInN5bmFwdGljc193cSIpOwogICAgaWYgKCFzeW5hcHRpY3Nfd3EpewogICAgICAg
IHByaW50ayhLRVJOX0VSUiAiQ291bGQgbm90IGNyZWF0ZSB3b3JrIHF1ZXVlIHN5bmFwdGljc193
cTogbm8gbWVtb3J5Iik7CiAgICAgICAgcmV0ID0gLUVOT01FTTsKICAgICAgICBnb3RvIGVycm9y
X3dxX2NyZWF0X2ZhaWxlZDsgCiAgICB9CgogICAgSU5JVF9XT1JLKCZ0cy0+d29yaywgc3luYXB0
aWNzX3JtaTRfd29ya19mdW5jKTsKICAgIHRzLT5pc19zdXBwb3J0X211bHRpX3RvdWNoID0gY2xp
ZW50LT5mbGFnczsKICAgIHRzLT5jbGllbnQgPSBjbGllbnQ7CiAgICBpMmNfc2V0X2NsaWVudGRh
dGEoY2xpZW50LCB0cyk7CgogICAgcmV0ID0gc3luYXB0aWNzX3JtaTRfcmVhZF9wZHQodHMpOwoK
ICAgIGlmKHRvdWNoX3BkYXRhLT5zZXRfdG91Y2hfcHJvYmVfZmxhZyl7CiAgICAgICAgdG91Y2hf
cGRhdGEtPnNldF90b3VjaF9wcm9iZV9mbGFnKHJldCk7CiAgICB9CiAgICAKICAgIGlmIChyZXQg
PD0gMCl7CiAgICAgICAgaWYgKHJldCA9PSAwKSBwcmludGsoS0VSTl9FUlIgIkVtcHR5IFBEVFxu
Iik7CiAgICAgICAgcHJpbnRrKEtFUk5fRVJSICJFcnJvciBpZGVudGlmeWluZyBkZXZpY2UgKCVk
KVxuIiwgcmV0KTsKICAgICAgICByZXQgPSAtRU5PREVWOwogICAgICAgIGdvdG8gZXJyX3BkdF9y
ZWFkX2ZhaWxlZDsKICAgIH0KCiNpZmRlZiBDT05GSUdfU1lOQVBUSUNTX1VQREFURV9STUlfVFNf
RklSTVdBUkUKICAgIGdfY2xpZW50ID0gY2xpZW50OyAgCiAgICBmb3IgKGkgPSAwIDsgaSA8IDM7
IGkrKykgCiAgICB7CiAgICAgICAgcmV0PSB0c19maXJtd2FyZV9maWxlKCk7ICAgCiAgICAgICAg
aWYgKCFyZXQpCiAgICAgICAgewogICAgICAgICAgYnJlYWs7CiAgICAgICAgfQogICAgfQojZW5k
aWYgLyogQ09ORklHX1NZTkFQVElDU19VUERBVEVfUk1JX1RTX0ZJUk1XQVJFICovCgogICAgdHNf
eF9tYXggPSAgdHMtPmYxMV9tYXhfeDsKICAgIHRzX3lfbWF4ID0gIHRzLT5mMTFfbWF4X3k7CiAg
ICAgICAgCiAgICBnZXRfaWNfbmFtZSgpOwogICAgaWYgKCgzMjAwID09IHRvdWNoX2ljX25hbWUp
fHwoMjIwMiA9PSB0b3VjaF9pY19uYW1lKSkKICAgIHsKICAgICAgICB0cF9yZWFkX2ZuMzRfaW5w
dXRfbmFtZSgpOwogICAgfQogICAgZWxzZQogICAgewogICAgICAgIHJldCA9IHRwX3JlYWRfaW5w
dXRfbmFtZSgpOwogICAgICAgIGlmKCFyZXQpCiAgICAgICAgewogICAgICAgICAgICBwcmludGso
InRoZSB0cCBpbnB1dCBuYW1lIGlzIHF1ZXJ5IGVycm9yIVxuICIpOwogICAgICAgIH0KICAgIH0K
CWRfZW50cnkgPSBjcmVhdGVfcHJvY19lbnRyeSgidHBfaHdfdHlwZSIsIFNfSVJVR08gfCBTX0lX
VVNSIHwgU19JV0dSUCwgTlVMTCk7CglpZiAoZF9lbnRyeSkgewoJCWRfZW50cnktPnJlYWRfcHJv
YyA9IHRwX3JlYWRfcHJvYzsKCQlkX2VudHJ5LT5kYXRhID0gTlVMTDsKCX0KICAgIAogICAgewog
ICAgICAgIFRTX0RFQlVHX1JNSSgidGhlIFJlcG9ydGluZ01vZGUgaXMgY2hhbmdnZWQgb2shXG4i
KTsKICAgIH0KICAgIAoJdHMtPmlucHV0X2RldiA9IGlucHV0X2FsbG9jYXRlX2RldmljZSgpOwoJ
aWYgKCF0cy0+aW5wdXRfZGV2KQogICAgewoJCXByaW50ayhLRVJOX0VSUiAiZmFpbGVkIHRvIGFs
bG9jYXRlIGlucHV0IGRldmljZS5cbiIpOwoJCXJldCA9IC1FQlVTWTsKCQlnb3RvIGVycl9hbGxv
Y19kZXZfZmFpbGVkOwoJfQoKCXRzLT5pbnB1dF9kZXYtPm5hbWUgPSAic3luYXB0aWNzIjsKCWRl
dl9zZXRfZHJ2ZGF0YSgmKHRzLT5pbnB1dF9kZXYtPmRldiksIHRzKTsKCXRzLT5pbnB1dF9kZXYt
PnBoeXMgPSBjbGllbnQtPm5hbWU7CglzZXRfYml0KEVWX0FCUywgdHMtPmlucHV0X2Rldi0+ZXZi
aXQpOwoJc2V0X2JpdChFVl9TWU4sIHRzLT5pbnB1dF9kZXYtPmV2Yml0KTsKCXNldF9iaXQoRVZf
S0VZLCB0cy0+aW5wdXRfZGV2LT5ldmJpdCk7CglzZXRfYml0KEJUTl9UT1VDSCwgdHMtPmlucHV0
X2Rldi0+a2V5Yml0KTsKCXNldF9iaXQoQUJTX1gsIHRzLT5pbnB1dF9kZXYtPmFic2JpdCk7Cglz
ZXRfYml0KEFCU19ZLCB0cy0+aW5wdXRfZGV2LT5hYnNiaXQpOwogICAgc2V0X2JpdChLRVlfTlVN
TE9DSywgdHMtPmlucHV0X2Rldi0+a2V5Yml0KTsKCXNldF9iaXQoSU5QVVRfUFJPUF9ESVJFQ1Qs
dHMtPmlucHV0X2Rldi0+cHJvcGJpdCk7CglyZXQgPSBpbnB1dF9yZWdpc3Rlcl9kZXZpY2UodHMt
PmlucHV0X2Rldik7CglpZiAocmV0KSAKICAgIHsKCQlwcmludGsoS0VSTl9FUlIgInN5bmFwdGlj
c19ybWk0X3Byb2JlOiBVbmFibGUgdG8gcmVnaXN0ZXIgJXMgXAoJCQkJaW5wdXQgZGV2aWNlXG4i
LCB0cy0+aW5wdXRfZGV2LT5uYW1lKTsKCQlyZXQgPSAtRU5PREVWOwoJCWdvdG8gZXJyX2lucHV0
X3JlZ2lzdGVyX2RldmljZV9mYWlsZWQ7Cgl9IAogICAgZWxzZSAKCXsKCQlUU19ERUJVR19STUko
InN5bmFwdGljcyBpbnB1dCBkZXZpY2UgcmVnaXN0ZXJlZFxuIik7Cgl9CgkKCWlmICh0cy0+aGFz
RjExKSB7CiNpZmRlZiBDT05GSUdfQVJDSF9NU003WDI3CiAgICAgICAgaWYgKG1hY2hpbmVfaXNf
bXNtN3gyN2FfTTY2MCgpKQogICAgICAgIHsKICAgICAgICAgICAgaWYgKHRzLT5mMTEucG9pbnRz
X3N1cHBvcnRlZCA+IDIpCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIHBvaW50X3N1cHBv
cnRlZF9odWF3ZWkgPSAyOwogICAgICAgICAgICB9CiAgICAgICAgICAgIGVsc2UKICAgICAgICAg
ICAgewogICAgICAgICAgICAgICAgcG9pbnRfc3VwcG9ydGVkX2h1YXdlaSA9IHRzLT5mMTEucG9p
bnRzX3N1cHBvcnRlZDsKICAgICAgICAgICAgfSAgCiAgICAgICAgfQogICAgICAgIGVsc2UKICAg
ICAgICB7CiAgICAgICAgICAgIGlmICh0cy0+ZjExLnBvaW50c19zdXBwb3J0ZWQgPiA1KQogICAg
ICAgICAgICB7CiAgICAgICAgICAgICAgICBwb2ludF9zdXBwb3J0ZWRfaHVhd2VpID0gNTsKICAg
ICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IHBvaW50X3N1cHBvcnRlZF9odWF3ZWkgPSB0cy0+ZjExLnBvaW50c19zdXBwb3J0ZWQ7CiAgICAg
ICAgICAgIH0KICAgICAgICB9CiNlbmRpZgojaWZkZWYgQ09ORklHX0FSQ0hfTVNNN1gzMAogICAg
ICAgCWlmIChtYWNoaW5lX2lzX21zbTgyNTVfYzg4NjAoKSkKICAgICAgICB7CiAgICAgICAgICAg
IGlmKEhXX1ZFUl9TVUJfVkMgPT0gZ2V0X2h3X3N1Yl9ib2FyZF9pZCgpKQoJCQl7CgkJCSAgICBp
ZiAodHMtPmYxMS5wb2ludHNfc3VwcG9ydGVkID4gMikgCgkJCQl7CgkJCQkgICAgcG9pbnRfc3Vw
cG9ydGVkX2h1YXdlaSA9IDI7CgkJCQl9ICAKCQkJCWVsc2UKCQkJCXsKCQkJCSAgICBwb2ludF9z
dXBwb3J0ZWRfaHVhd2VpID0gdHMtPmYxMS5wb2ludHNfc3VwcG9ydGVkOwoJCQkJfQoJCQl9CgkJ
CWVsc2UKCQkJewoJCQkgICAgaWYgKHRzLT5mMTEucG9pbnRzX3N1cHBvcnRlZCA+IDUpCiAgICAg
ICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgcG9pbnRfc3VwcG9ydGVkX2h1YXdlaSA9
IDU7CiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAg
ICB7CiAgICAgICAgICAgICAgICAgICAgcG9pbnRfc3VwcG9ydGVkX2h1YXdlaSA9IHRzLT5mMTEu
cG9pbnRzX3N1cHBvcnRlZDsKICAgICAgICAgICAgICAgIH0KCQkJfQkJCiAgICAgICAgfQogICAg
ICAgIGVsc2UKICAgICAgICB7CiAgICAgICAgICAgIGlmICh0cy0+ZjExLnBvaW50c19zdXBwb3J0
ZWQgPiA1KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBwb2ludF9zdXBwb3J0ZWRfaHVh
d2VpID0gNTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsKICAg
ICAgICAgICAgICAgIHBvaW50X3N1cHBvcnRlZF9odWF3ZWkgPSB0cy0+ZjExLnBvaW50c19zdXBw
b3J0ZWQ7CiAgICAgICAgICAgIH0KICAgICAgICB9CiNlbmRpZgoKCQlmb3IgKGkgPSAwOyBpIDwg
dHMtPmYxMS5wb2ludHNfc3VwcG9ydGVkOyArK2kpIHsKICAgICAgICAgIGlmKHRzLT5pc19zdXBw
b3J0X211bHRpX3RvdWNoKQogICAgICAgICAgewoKCQkJaW5wdXRfc2V0X2Fic19wYXJhbXModHMt
PmlucHV0X2RldiwgQUJTX01UX1RSQUNLSU5HX0lELCAxLAogICAgICAgICAgICAgICAgICAgIAkJ
CXRzLT5mMTEucG9pbnRzX3N1cHBvcnRlZCwgMCwgMCk7CgkJCWlucHV0X3NldF9hYnNfcGFyYW1z
KHRzLT5pbnB1dF9kZXYsIEFCU19NVF9QT1NJVElPTl9YLCAwLCBsY2RfeCAtIDEsIDAsIDApOwoJ
CQlpbnB1dF9zZXRfYWJzX3BhcmFtcyh0cy0+aW5wdXRfZGV2LCBBQlNfTVRfUE9TSVRJT05fWSwg
MCwgbGNkX3kgLSAxLCAwLCAwKTsKCQkJaW5wdXRfc2V0X2Fic19wYXJhbXModHMtPmlucHV0X2Rl
diwgQUJTX01UX1RPVUNIX01BSk9SLCAwLCAweEYsIDAsIDApOwoJCQlpbnB1dF9zZXRfYWJzX3Bh
cmFtcyh0cy0+aW5wdXRfZGV2LCBBQlNfTVRfVE9VQ0hfTUlOT1IsIDAsIDB4RiwgMCwgMCk7CgkJ
CWlucHV0X3NldF9hYnNfcGFyYW1zKHRzLT5pbnB1dF9kZXYsIEFCU19NVF9PUklFTlRBVElPTiwg
MCwgMSwgMCwgMCk7CgkJCWlucHV0X3NldF9hYnNfcGFyYW1zKHRzLT5pbnB1dF9kZXYsIEFCU19N
VF9QUkVTU1VSRSwgMCwJMjU1LCAwLCAwKTsKICAgICAgICAgIH0KICAgICAgICAgIGVsc2UKICAg
ICAgICAgIHsKICAgICAgICAgICAgaW5wdXRfc2V0X2Fic19wYXJhbXModHMtPmlucHV0X2Rldiwg
QUJTX1gsIDAsIGxjZF94LTEsIDAsIDApOwogICAgICAgICAgICBpbnB1dF9zZXRfYWJzX3BhcmFt
cyh0cy0+aW5wdXRfZGV2LCBBQlNfWSwgMCwgbGNkX3ktMSwgMCwgMCk7CiAgICAgICAgICAgIGlu
cHV0X3NldF9hYnNfcGFyYW1zKHRzLT5pbnB1dF9kZXYsIEFCU19QUkVTU1VSRSwgMCwgMjU1LCAw
LCAwKTsKICAgICAgICAgICAgICAgIAogICAgICAgICAgfQoKCQl9CgkJaWYgKHRzLT5oYXNFZ3JQ
YWxtRGV0ZWN0KQoJCQlzZXRfYml0KEJUTl9ERUFELCB0cy0+aW5wdXRfZGV2LT5rZXliaXQpOwoJ
CWlmICh0cy0+aGFzRWdyRmxpY2spIHsKCQkJc2V0X2JpdChSRUxfWCwgdHMtPmlucHV0X2Rldi0+
a2V5Yml0KTsKCQkJc2V0X2JpdChSRUxfWSwgdHMtPmlucHV0X2Rldi0+a2V5Yml0KTsKCQl9CgkJ
aWYgKHRzLT5oYXNFZ3JTaW5nbGVUYXApCgkJCXNldF9iaXQoQlROX1RPVUNILCB0cy0+aW5wdXRf
ZGV2LT5rZXliaXQpOwoJCWlmICh0cy0+aGFzRWdyRG91YmxlVGFwKQoJCQlzZXRfYml0KEJUTl9U
T09MX0RPVUJMRVRBUCwgdHMtPmlucHV0X2Rldi0+a2V5Yml0KTsKCX0KCWlmICh0cy0+aGFzRjE5
KSB7CgkJc2V0X2JpdChCVE5fREVBRCwgdHMtPmlucHV0X2Rldi0+a2V5Yml0KTsKCX0KCWlmICh0
cy0+aGFzRjMwKSB7CgkJZm9yIChpID0gMDsgaSA8IHRzLT5mMzAucG9pbnRzX3N1cHBvcnRlZDsg
KytpKSB7CgkJCXNldF9iaXQoQlROX0YzMCArIGksIHRzLT5pbnB1dF9kZXYtPmtleWJpdCk7CgkJ
fQoJfQoKCiAgICAKICAgIGlmKHRvdWNoX3BkYXRhLT50b3VjaF9ncGlvX2NvbmZpZ19pbnRlcnJ1
cHQpCiAgICB7CiAgICAgICAgcmV0ID0gdG91Y2hfcGRhdGEtPnRvdWNoX2dwaW9fY29uZmlnX2lu
dGVycnVwdCgpOwogICAgfQoKCglpZiAoY2xpZW50LT5pcnEpIHsKCQlncGlvX3JlcXVlc3QoY2xp
ZW50LT5pcnEsIGNsaWVudC0+bmFtZSk7CgkJZ3Bpb19kaXJlY3Rpb25faW5wdXQoY2xpZW50LT5p
cnEpOwoKCQlUU19ERUJVR19STUkoIlJlcXVlc3RpbmcgSVJRLi4uXG4iKTsKCgkJaWYgKHJlcXVl
c3RfaXJxKGNsaWVudC0+aXJxLCBzeW5hcHRpY3Nfcm1pNF9pcnFfaGFuZGxlciwKCQkJCUlSUUZf
VFJJR0dFUl9MT1csIGNsaWVudC0+bmFtZSwgdHMpID49IDApIHsKCQkJVFNfREVCVUdfUk1JKCJS
ZWNlaXZlZCBJUlEhXG4iKTsKCQkJdHMtPnVzZV9pcnEgPSAxOwoJCQkjaWYgMAoJCQlpZiAoc2V0
X2lycV93YWtlKGNsaWVudC0+aXJxLCAxKSA8IDApCgkJCQlwcmludGsoS0VSTl9FUlIgImZhaWxl
ZCB0byBzZXQgSVJRIHdha2VcbiIpOwoJCQkjZW5kaWYKCQl9IGVsc2UgewoJCQlUU19ERUJVR19S
TUkoIkZhaWxlZCB0byByZXF1ZXN0IElSUSFcbiIpOwoJCX0KCX0KCglpZiAoIXRzLT51c2VfaXJx
KSB7CgkJcHJpbnRrKEtFUk5fRVJSICJTeW5hcHRpY3MgUk1JNCBkZXZpY2UgJXMgaW4gcG9sbGlu
ZyBtb2RlXG4iLCBjbGllbnQtPm5hbWUpOwoJCWhydGltZXJfaW5pdCgmdHMtPnRpbWVyLCBDTE9D
S19NT05PVE9OSUMsIEhSVElNRVJfTU9ERV9SRUwpOwoJCXRzLT50aW1lci5mdW5jdGlvbiA9IHN5
bmFwdGljc19ybWk0X3RpbWVyX2Z1bmM7CgkJaHJ0aW1lcl9zdGFydCgmdHMtPnRpbWVyLCBrdGlt
ZV9zZXQoMSwgMCksIEhSVElNRVJfTU9ERV9SRUwpOwoJfQoKCgl0cy0+ZW5hYmxlID0gMTsKCglk
ZXZfc2V0X2RydmRhdGEoJnRzLT5pbnB1dF9kZXYtPmRldiwgdHMpOwoKCWlmIChzeXNmc19jcmVh
dGVfZmlsZSgmdHMtPmlucHV0X2Rldi0+ZGV2LmtvYmosICZkZXZfYXR0cl9zeW5hcHRpY3Nfcm1p
NF9lbmFibGUuYXR0cikgPCAwKQoJCXByaW50aygiZmFpbGVkIHRvIGNyZWF0ZSBzeXNmcyBmaWxl
IGZvciBpbnB1dCBkZXZpY2VcbiIpOwoKCSNpZmRlZiBDT05GSUdfSEFTX0VBUkxZU1VTUEVORAoJ
dHMtPmVhcmx5X3N1c3BlbmQubGV2ZWwgPSBFQVJMWV9TVVNQRU5EX0xFVkVMX0JMQU5LX1NDUkVF
TiArIDE7Cgl0cy0+ZWFybHlfc3VzcGVuZC5zdXNwZW5kID0gc3luYXB0aWNzX3JtaTRfZWFybHlf
c3VzcGVuZDsKCXRzLT5lYXJseV9zdXNwZW5kLnJlc3VtZSA9IHN5bmFwdGljc19ybWk0X2xhdGVf
cmVzdW1lOwoJcmVnaXN0ZXJfZWFybHlfc3VzcGVuZCgmdHMtPmVhcmx5X3N1c3BlbmQpOwoJI2Vu
ZGlmCglwcmludGsoS0VSTl9FUlIgInByb2JpbmdYIGZvciBTeW5hcHRpY3MgUk1JNCBkZXZpY2Ug
JXMgYXQgJCUwMlguLi5cbiIsIGNsaWVudC0+bmFtZSwgY2xpZW50LT5hZGRyKTsKICAgICNpZmRl
ZiBDT05GSUdfSFVBV0VJX0hXX0RFVl9EQ1QKICAgIHNldF9od19kZXZfZmxhZyhERVZfSTJDX1RP
VUNIX1BBTkVMKTsKICAgICNlbmRpZgoKICAgIHJldHVybiAwOwoKZXJyX2lucHV0X3JlZ2lzdGVy
X2RldmljZV9mYWlsZWQ6CiAgICBpZihOVUxMICE9IHRzLT5pbnB1dF9kZXYpCgkgICAgaW5wdXRf
ZnJlZV9kZXZpY2UodHMtPmlucHV0X2Rldik7CmVycl9wZHRfcmVhZF9mYWlsZWQ6CmVycl9hbGxv
Y19kZXZfZmFpbGVkOgplcnJvcl93cV9jcmVhdF9mYWlsZWQ6CiAgICBpZiAoc3luYXB0aWNzX3dx
KQogICAgeyAgIAogICAgICAgIGRlc3Ryb3lfd29ya3F1ZXVlKHN5bmFwdGljc193cSk7CiAgICB9
CiAgICBpZiAoc3luYXB0aWNzX3dxICE9IE5VTEwpIHN5bmFwdGljc193cSA9IE5VTEw7CiAgICBp
ZihOVUxMICE9IHRzKQogICAgICAgIGtmcmVlKHRzKTsKZXJyX2FsbG9jX2RhdGFfZmFpbGVkOgpl
cnJfY2hlY2tfZnVuY3Rpb25hbGl0eV9mYWlsZWQ6CgogICAgLyogY2FuJ3QgdXNlIHRoZSBmbGFn
IHJldCBoZXJlLCBpdCB3aWxsIGNoYW5nZSB0aGUgcmV0dXJuIHZhbHVlIG9mIHByb2JlIGZ1bmN0
aW9uICovCiAgICB0b3VjaF9wZGF0YS0+dG91Y2hfcG93ZXIoMCk7CiAgICAvKiBkZWxldGUgMyBs
aW5lcyAqLwplcnJfcGxhdGZvcm1fZGF0YV9pbml0X2ZhaWxlZDoKCmVycl9wb3dlcl9vbl9mYWls
ZWQ6CiAgICBUU19ERUJVR19STUkoIlRIRSBQT1dFUiBJUyBGQUlMRUQhISFcbiIpOwoKCXJldHVy
biByZXQ7Cn0KCgpzdGF0aWMgaW50IHN5bmFwdGljc19ybWk0X3JlbW92ZShzdHJ1Y3QgaTJjX2Ns
aWVudCAqY2xpZW50KQp7CnN0cnVjdCBzeW5hcHRpY3Nfcm1pNCAqdHMgPSBpMmNfZ2V0X2NsaWVu
dGRhdGEoY2xpZW50KTsKCXVucmVnaXN0ZXJfZWFybHlfc3VzcGVuZCgmdHMtPmVhcmx5X3N1c3Bl
bmQpOwoJaWYgKHRzLT51c2VfaXJxKQoJCWZyZWVfaXJxKGNsaWVudC0+aXJxLCB0cyk7CgllbHNl
CgkJaHJ0aW1lcl9jYW5jZWwoJnRzLT50aW1lcik7CglpbnB1dF91bnJlZ2lzdGVyX2RldmljZSh0
cy0+aW5wdXRfZGV2KTsKCWtmcmVlKHRzKTsKCXJldHVybiAwOwp9CgpzdGF0aWMgaW50IHN5bmFw
dGljc19ybWk0X3N1c3BlbmQoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwgcG1fbWVzc2FnZV90
IG1lc2cpCnsKICAgIGludCByZXQ7CglzdHJ1Y3Qgc3luYXB0aWNzX3JtaTQgKnRzID0gaTJjX2dl
dF9jbGllbnRkYXRhKGNsaWVudCk7Ci8qIGlmIHVzZSBpbnRlcnJ1cHQgZGlzYWJsZSB0aGUgaXJx
ICxlbHNlIGRpc2FibGUgdGltZXIgKi8gCiAgICBpZiAodHMtPnVzZV9pcnEpCgkgICAgZGlzYWJs
ZV9pcnFfbm9zeW5jKGNsaWVudC0+aXJxKTsKCWVsc2UKCQlocnRpbWVyX2NhbmNlbCgmdHMtPnRp
bWVyKTsKCglyZXQgPSBjYW5jZWxfd29ya19zeW5jKCZ0cy0+d29yayk7ICAgIAoJaWYgKHJldCAm
JiB0cy0+dXNlX2lycSkgLyogaWYgd29yayB3YXMgcGVuZGluZyBkaXNhYmxlLWNvdW50IGlzIG5v
dyAyICovCiAgICB7ICAgCiAgICAgICAgZW5hYmxlX2lycShjbGllbnQtPmlycSk7CiAgICAgICAg
cHJpbnRrKEtFUk5fRVJSICJzeW5hcHRpY3NfdHNfc3VzcGVuZDogY2FuJ3QgY2FuY2VsIHRoZSB3
b3JrICxzbyBlbmFibGUgdGhlIGlycSBcbiIpOwogICAgfQogICAgcmV0ID0gaTJjX3NtYnVzX3dy
aXRlX2J5dGVfZGF0YShjbGllbnQsIGZkXzAxLmNvbnRyb2xCYXNlLCAweDAxKTsgLy91c2UgY29u
dHJvbCBiYXNlIHRvIHNldCB0cCBzbGVlcAogICAgaWYocmV0IDwgMCkKICAgIHsKICAgICAgICBw
cmludGsoS0VSTl9FUlIgInN5bmFwdGljc190c19zdXNwZW5kOiB0aGUgdG91Y2ggY2FuJ3QgZ2V0
IGludG8gZGVlcCBzbGVlcCBcbiIpOwogICAgfQoKCXRzLT5lbmFibGUgPSAwOwoKCXJldHVybiAw
Owp9CgpzdGF0aWMgaW50IHN5bmFwdGljc19ybWk0X3Jlc3VtZShzdHJ1Y3QgaTJjX2NsaWVudCAq
Y2xpZW50KQp7CiAgICBpbnQgcmV0OwoJc3RydWN0IHN5bmFwdGljc19ybWk0ICp0cyA9IGkyY19n
ZXRfY2xpZW50ZGF0YShjbGllbnQpOwogICAgCiAgICAKICAgIHJldCA9IGkyY19zbWJ1c193cml0
ZV9ieXRlX2RhdGEodHMtPmNsaWVudCwgZmRfMDEuY29udHJvbEJhc2UsIDB4MDApOyAvL3VzZSBj
b250cm9sIGJhc2UgdG8gc2V0IHRwIHdha2V1cAogICAgaWYocmV0IDwgMCkKICAgIHsKICAgICAg
ICBwcmludGsoS0VSTl9FUlIgInN5bmFwdGljc190c19yZXN1bWU6IHRoZSB0b3VjaCBjYW4ndCBy
ZXN1bWUhIFxuIik7CiAgICB9CiAgICBtZGVsYXkoNTApOwogICAgaWYgKHRzLT51c2VfaXJxKSB7
CgkJZW5hYmxlX2lycShjbGllbnQtPmlycSk7Cgl9CgllbHNlCgkJaHJ0aW1lcl9zdGFydCgmdHMt
PnRpbWVyLCBrdGltZV9zZXQoMSwgMCksIEhSVElNRVJfTU9ERV9SRUwpOwogICAgcHJpbnRrKEtF
Uk5fRVJSICJzeW5hcHRpY3Nfcm1pNF90b3VjaCBpcyByZXN1bWUhXG4iKTsKCglyZXR1cm4gMDsK
fQoKI2lmZGVmIENPTkZJR19IQVNfRUFSTFlTVVNQRU5ECnN0YXRpYyB2b2lkIHN5bmFwdGljc19y
bWk0X2Vhcmx5X3N1c3BlbmQoc3RydWN0IGVhcmx5X3N1c3BlbmQgKmgpCnsKCXN0cnVjdCBzeW5h
cHRpY3Nfcm1pNCAqdHM7Cgl0cyA9IGNvbnRhaW5lcl9vZihoLCBzdHJ1Y3Qgc3luYXB0aWNzX3Jt
aTQsIGVhcmx5X3N1c3BlbmQpOwoJc3luYXB0aWNzX3JtaTRfc3VzcGVuZCh0cy0+Y2xpZW50LCBQ
TVNHX1NVU1BFTkQpOwp9CgpzdGF0aWMgdm9pZCBzeW5hcHRpY3Nfcm1pNF9sYXRlX3Jlc3VtZShz
dHJ1Y3QgZWFybHlfc3VzcGVuZCAqaCkKewoJc3RydWN0IHN5bmFwdGljc19ybWk0ICp0czsKCXRz
ID0gY29udGFpbmVyX29mKGgsIHN0cnVjdCBzeW5hcHRpY3Nfcm1pNCwgZWFybHlfc3VzcGVuZCk7
CglzeW5hcHRpY3Nfcm1pNF9yZXN1bWUodHMtPmNsaWVudCk7Cn0KI2VuZGlmCgovKmFkZCB0aGUg
dXBkYXRlIGZpcm13YXJlIHByb2dyb20qLwojaWZkZWYgQ09ORklHX1NZTkFQVElDU19VUERBVEVf
Uk1JX1RTX0ZJUk1XQVJFCnN0cnVjdCBSTUk0X0ZEVHsKICAgIHVuc2lnbmVkIGNoYXIgbV9RdWVy
eUJhc2U7CiAgICB1bnNpZ25lZCBjaGFyIG1fQ29tbWFuZEJhc2U7CiAgICB1bnNpZ25lZCBjaGFy
IG1fQ29udHJvbEJhc2U7CiAgICB1bnNpZ25lZCBjaGFyIG1fRGF0YUJhc2U7CiAgICB1bnNpZ25l
ZCBjaGFyIG1fSW50U291cmNlQ291bnQ7CiAgICB1bnNpZ25lZCBjaGFyIG1fSUQ7Cn07CgpzdGF0
aWMgaW50IFJNSTRfcmVhZF9QRFQoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCkKewoJLy8gUmVh
ZCBjb25maWcgZGF0YQoJc3RydWN0IFJNSTRfRkRUIHRlbXBfYnVmOwoJc3RydWN0IFJNSTRfRkRU
IG1fUGR0RjM0Rmxhc2g7CglzdHJ1Y3QgUk1JNF9GRFQgbV9QZHRGMDFDb21tb247CglzdHJ1Y3Qg
aTJjX21zZyBtc2dbMl07Cgl1bnNpZ25lZCBzaG9ydCBzdGFydF9hZGRyOyAKCWludCByZXQgPSAw
OwoKCW1lbXNldCgmbV9QZHRGMzRGbGFzaCwwLHNpemVvZihzdHJ1Y3QgUk1JNF9GRFQpKTsKCW1l
bXNldCgmbV9QZHRGMDFDb21tb24sMCxzaXplb2Yoc3RydWN0IFJNSTRfRkRUKSk7CgoJZm9yKHN0
YXJ0X2FkZHIgPSAweGU5OyBzdGFydF9hZGRyID4gMTA7IHN0YXJ0X2FkZHIgLT0gc2l6ZW9mKHN0
cnVjdCBSTUk0X0ZEVCkpCgl7CgkJbXNnWzBdLmFkZHIgPSBjbGllbnQtPmFkZHI7CgkJbXNnWzBd
LmZsYWdzID0gMDsKCQltc2dbMF0ubGVuID0gMTsKCQltc2dbMF0uYnVmID0gKHVuc2lnbmVkIGNo
YXIgKikmc3RhcnRfYWRkcjsKCQltc2dbMV0uYWRkciA9IGNsaWVudC0+YWRkcjsKCQltc2dbMV0u
ZmxhZ3MgPSBJMkNfTV9SRDsKCQltc2dbMV0ubGVuID0gc2l6ZW9mKHN0cnVjdCBSTUk0X0ZEVCk7
CgkJbXNnWzFdLmJ1ZiA9ICh1bnNpZ25lZCBjaGFyICopJnRlbXBfYnVmOwoJCQoJCWlmKGkyY190
cmFuc2ZlcihjbGllbnQtPmFkYXB0ZXIsIG1zZywgMikgPCAwKQoJCXsKCQkJcHJpbnRrKCIlczol
ZDogcmVhZCBSSU00IFBEVCBlcnJvciFcbiIsX19GVU5DVElPTl9fLF9fTElORV9fKTsKCQkJcmV0
dXJuIC0xOwoJCX0KCgkJaWYodGVtcF9idWYubV9JRCA9PSAweDM0KQoJCXsKCQkJbWVtY3B5KCZt
X1BkdEYzNEZsYXNoLCZ0ZW1wX2J1ZixzaXplb2Yoc3RydWN0IFJNSTRfRkRUICkpOwoJCX0KCQll
bHNlIGlmKHRlbXBfYnVmLm1fSUQgPT0gMHgwMSkKCQl7CgkJCW1lbWNweSgmbV9QZHRGMDFDb21t
b24sJnRlbXBfYnVmLHNpemVvZihzdHJ1Y3QgUk1JNF9GRFQgKSk7CgkJfQoJCWVsc2UgaWYgKHRl
bXBfYnVmLm1fSUQgPT0gMCkgIC8vZW5kIG9mIFBEVAoJCXsJCQoJCQlicmVhazsKCQl9CgkgIH0K
CglpZigobV9QZHRGMDFDb21tb24ubV9Db21tYW5kQmFzZSAhPSBmZF8wMS5jb21tYW5kQmFzZSkg
fHwgKG1fUGR0RjM0Rmxhc2gubV9RdWVyeUJhc2UgIT0gZmRfMzQucXVlcnlCYXNlKSkKCXsKCQlw
cmludGsoIiVzOiVkOiBSSU00IFBEVCBoYXMgY2hhbmdlZCEhIVxuIixfX0ZVTkNUSU9OX18sX19M
SU5FX18pOwoJCQoJCXJldCA9IHN5bmFwdGljc19ybWk0X3JlYWRfcGR0KHRzKTsKCQlpZihyZXQg
PCAwKQoJCXsKCQkJcHJpbnRrKCJyZWFkIHBkdCBlcnJvcjohXG4iKTsKCQkJcmV0dXJuIC0xOwoJ
CX0KCQkKCQlyZXR1cm4gMDsKCX0KCglyZXR1cm4gMDsKCn0KCi8vdG8gYmUgaW1wcm92ZWQgLi4u
Li4uLgppbnQgUk1JNF93YWl0X2F0dG4oc3RydWN0IGkyY19jbGllbnQgKiBjbGllbnQsaW50IHVk
bGVheSkKewoJaW50IGxvb3BfY291bnQ9MDsKCWludCByZXQ9MDsKCglkb3sKCQltZGVsYXkodWRs
ZWF5KTsKCQlyZXQgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LGZkXzM0LmRhdGFC
YXNlKzE4KTsvL3JlYWQgRmxhc2ggQ29udHJvbAoJCS8vIENsZWFyIHRoZSBhdHRlbnRpb24gYXNz
ZXJ0aW9uIGJ5IHJlYWRpbmcgdGhlIGludGVycnVwdCBzdGF0dXMgcmVnaXN0ZXIKCQlpMmNfc21i
dXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LGZkXzAxLmRhdGFCYXNlKzEpOy8vcmVhZCB0aGUgaXJx
IEludGVycnVwdCBTdGF0dXMKCX13aGlsZShsb29wX2NvdW50KysgPCAweDEwICYmIChyZXQgIT0g
MHg4MCkpOwoKCWlmKGxvb3BfY291bnQgPj0gMHgxMCkKCXsKCQlTWU5BUElUSUNTX0RFQlVHKCJS
TUk0IHdhaXQgYXR0biB0aW1lb3V0OnJldD0weCV4XG4iLHJldCk7CgkJcmV0dXJuIC0xOwoJfQoJ
cmV0dXJuIDA7Cn0KCmludCBSTUk0X2Rpc2FibGVfcHJvZ3JhbShzdHJ1Y3QgaTJjX2NsaWVudCAq
Y2xpZW50KQp7Cgl1bnNpZ25lZCBjaGFyIGNkYXRhOyAKCXVuc2lnbmVkIGludCBsb29wX2NvdW50
PTA7CiAgCglwcmludGsoIlJNSTQgZGlzYWJsZSBwcm9ncmFtLi4uXG4iKTsKCS8vIElzc3VlIGEg
cmVzZXQgY29tbWFuZAoJaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQsZmRfMDEuY29t
bWFuZEJhc2UsMHgwMSk7CgoJLy8gV2FpdCBmb3IgQVRUTiB0byBiZSBhc3NlcnRlZCB0byBzZWUg
aWYgZGV2aWNlIGlzIGluIGlkbGUgc3RhdGUKCVJNSTRfd2FpdF9hdHRuKGNsaWVudCwyMCk7CgoJ
Ly8gUmVhZCBGMDEgU3RhdHVzIGZsYXNoIHByb2csIGVuc3VyZSB0aGUgNnRoIGJpdCBpcyAnMCcK
CWRvewoJCWNkYXRhID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCxmZF8wMS5kYXRh
QmFzZSk7CgkJdWRlbGF5KDIpOwoJfSB3aGlsZSgoKGNkYXRhICYgMHg0MCkgIT0gMCkgJiYgKGxv
b3BfY291bnQrKyA8IDEwKSk7CgoJLy9SZXNjYW4gdGhlIFBhZ2UgRGVzY3JpcHRpb24gVGFibGUK
CXJldHVybiBSTUk0X3JlYWRfUERUKGNsaWVudCk7Cn0KCnN0YXRpYyBpbnQgUk1JNF9lbmFibGVf
cHJvZ3JhbShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50KQp7Cgl1bnNpZ25lZCBzaG9ydCBib290
bG9hZGVyX2lkID0gMCA7CglpbnQgcmV0ID0gLTE7CglwcmludGsoIlJNSTQgZW5hYmxlIHByb2dy
YW0uLi5cbiIpOwoJIC8vIFJlYWQgYW5kIHdyaXRlIGJvb3Rsb2FkIElECglib290bG9hZGVyX2lk
ID0gaTJjX3NtYnVzX3JlYWRfd29yZF9kYXRhKGNsaWVudCxmZF8zNC5xdWVyeUJhc2UpOwoJaTJj
X3NtYnVzX3dyaXRlX3dvcmRfZGF0YShjbGllbnQsZmRfMzQuZGF0YUJhc2UrMixib290bG9hZGVy
X2lkKTsvL3dyaXRlIEJsb2NrIERhdGEgMAoKCSAgLy8gSXNzdWUgRW5hYmxlIGZsYXNoIGNvbW1h
bmQKCWlmKGkyY19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xpZW50LCBmZF8zNC5kYXRhQmFzZSsx
OCwgMHgwRikgPCAwKSAvL3dyaXRlIEZsYXNoIENvbnRyb2wKCXsKCQlTWU5BUElUSUNTX0RFQlVH
KCJSTUkgZW50ZXIgZmxhc2ggbW9kZSBlcnJvclxuIik7CgkJcmV0dXJuIC0xOwoJfQoJcmV0ID0g
Uk1JNF93YWl0X2F0dG4oY2xpZW50LDEyKTsKCgkvL1Jlc2NhbiB0aGUgUGFnZSBEZXNjcmlwdGlv
biBUYWJsZQoJUk1JNF9yZWFkX1BEVChjbGllbnQpOwoJcmV0dXJuIHJldDsKfQoKc3RhdGljIHVu
c2lnbmVkIGxvbmcgRXh0cmFjdExvbmdGcm9tSGVhZGVyKGNvbnN0IHVuc2lnbmVkIGNoYXIqIFN5
bmFJbWFnZSkgCnsKICAJcmV0dXJuKCh1bnNpZ25lZCBsb25nKVN5bmFJbWFnZVswXSArCiAgICAg
ICAgICh1bnNpZ25lZCBsb25nKVN5bmFJbWFnZVsxXSoweDEwMCArCiAgICAgICAgICh1bnNpZ25l
ZCBsb25nKVN5bmFJbWFnZVsyXSoweDEwMDAwICsKICAgICAgICAgKHVuc2lnbmVkIGxvbmcpU3lu
YUltYWdlWzNdKjB4MTAwMDAwMCk7Cn0KCnN0YXRpYyBpbnQgUk1JNF9jaGVja19maXJtd2FyZShz
dHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LGNvbnN0IHVuc2lnbmVkIGNoYXIgKnBnbV9kYXRhKQp7
Cgl1bnNpZ25lZCBsb25nIGNoZWNrU3VtQ29kZTsKCXVuc2lnbmVkIGxvbmcgbV9maXJtd2FyZUlt
Z1NpemU7Cgl1bnNpZ25lZCBsb25nIG1fY29uZmlnSW1nU2l6ZTsKCXVuc2lnbmVkIHNob3J0IG1f
Ym9vdGxvYWRJbWdJRDsgCgl1bnNpZ25lZCBzaG9ydCBib290bG9hZGVyX2lkOwoJY29uc3QgdW5z
aWduZWQgY2hhciAqU3luYUZpcm13YXJlOwoJdW5zaWduZWQgY2hhciBtX2Zpcm13YXJlSW1nVmVy
c2lvbjsKCXVuc2lnbmVkIHNob3J0IFVJX2Jsb2NrX2NvdW50OwoJdW5zaWduZWQgc2hvcnQgQ09O
Rl9ibG9ja19jb3VudDsKCXVuc2lnbmVkIHNob3J0IGZ3X2Jsb2NrX3NpemU7CgogIAlTeW5hRmly
bXdhcmUgPSBwZ21fZGF0YTsKCWNoZWNrU3VtQ29kZSA9IEV4dHJhY3RMb25nRnJvbUhlYWRlcigm
KFN5bmFGaXJtd2FyZVswXSkpOwoJbV9ib290bG9hZEltZ0lEID0gKHVuc2lnbmVkIGludClTeW5h
RmlybXdhcmVbNF0gKyAodW5zaWduZWQgaW50KVN5bmFGaXJtd2FyZVs1XSoweDEwMDsKCW1fZmly
bXdhcmVJbWdWZXJzaW9uID0gU3luYUZpcm13YXJlWzddOwoJbV9maXJtd2FyZUltZ1NpemUgICAg
PSBFeHRyYWN0TG9uZ0Zyb21IZWFkZXIoJihTeW5hRmlybXdhcmVbOF0pKTsKCW1fY29uZmlnSW1n
U2l6ZSAgICAgID0gRXh0cmFjdExvbmdGcm9tSGVhZGVyKCYoU3luYUZpcm13YXJlWzEyXSkpOwog
CglVSV9ibG9ja19jb3VudCAgPSBpMmNfc21idXNfcmVhZF93b3JkX2RhdGEoY2xpZW50LGZkXzM0
LnF1ZXJ5QmFzZSs1KTsvL3JlYWQgRmlybXdhcmUgQmxvY2sgQ291bnQgMAoJZndfYmxvY2tfc2l6
ZSA9IGkyY19zbWJ1c19yZWFkX3dvcmRfZGF0YShjbGllbnQsZmRfMzQucXVlcnlCYXNlKzMpOy8v
cmVhZCBCbG9jayBTaXplIDAKCUNPTkZfYmxvY2tfY291bnQgPSBpMmNfc21idXNfcmVhZF93b3Jk
X2RhdGEoY2xpZW50LGZkXzM0LnF1ZXJ5QmFzZSs3KTsvL3JlYWQgQ29uZmlndXJhdGlvbiBCbG9j
ayBDb3VudCAwCglib290bG9hZGVyX2lkID0gaTJjX3NtYnVzX3JlYWRfd29yZF9kYXRhKGNsaWVu
dCxmZF8zNC5xdWVyeUJhc2UpOwoKCXJldHVybiAobV9maXJtd2FyZUltZ1ZlcnNpb24gIT0gMCB8
fCBib290bG9hZGVyX2lkID09IG1fYm9vdGxvYWRJbWdJRCkgPyAwIDogLTE7Cgp9CgoKc3RhdGlj
IGludCBSTUk0X3dyaXRlX2ltYWdlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsdW5zaWduZWQg
Y2hhciB0eXBlX2NtZCxjb25zdCB1bnNpZ25lZCBjaGFyICpwZ21fZGF0YSkKewoJdW5zaWduZWQg
c2hvcnQgYmxvY2tfc2l6ZTsKCXVuc2lnbmVkIHNob3J0IGltZ19ibG9ja3M7Cgl1bnNpZ25lZCBz
aG9ydCBibG9ja19pbmRleDsKCWNvbnN0IHVuc2lnbmVkIGNoYXIgKiBwX2RhdGE7CglpbnQgaTsK
CglibG9ja19zaXplID0gaTJjX3NtYnVzX3JlYWRfd29yZF9kYXRhKGNsaWVudCxmZF8zNC5xdWVy
eUJhc2UrMyk7Ly9yZWFkIEJsb2NrIFNpemUgMAoJCglzd2l0Y2godHlwZV9jbWQgKQoJewoJCWNh
c2UgMHgwMjoKCQkJaW1nX2Jsb2NrcyA9IGkyY19zbWJ1c19yZWFkX3dvcmRfZGF0YShjbGllbnQs
ZmRfMzQucXVlcnlCYXNlKzUpOwkvL3JlYWQgVUkgRmlybXdhcmUKCQkJYnJlYWs7CgkJY2FzZSAw
eDA2OgoJCQlpbWdfYmxvY2tzID0gaTJjX3NtYnVzX3JlYWRfd29yZF9kYXRhKGNsaWVudCxmZF8z
NC5xdWVyeUJhc2UrNyk7CS8vcmVhZCBDb25maWd1cmF0aW9uIEJsb2NrIENvdW50IDAJCgkJCWJy
ZWFrOwoJCWRlZmF1bHQ6CgkJCVNZTkFQSVRJQ1NfREVCVUcoImltYWdlIHR5cGUgZXJyb3JcbiIp
OwoJCQlnb3RvIGVycm9yOwoJfQoKCXBfZGF0YSA9IHBnbV9kYXRhOwoJCglmb3IoYmxvY2tfaW5k
ZXggPSAwOyBibG9ja19pbmRleCA8IGltZ19ibG9ja3M7ICsrYmxvY2tfaW5kZXgpCgl7CgkJcHJp
bnRrKCIjIik7CgkJaWYoaTJjX3NtYnVzX3dyaXRlX3dvcmRfZGF0YShjbGllbnQsIGZkXzM0LmRh
dGFCYXNlLGJsb2NrX2luZGV4KSA8IDApCgkJewoJCQlTWU5BUElUSUNTX0RFQlVHKCJ3cml0ZSBi
bG9jayBudW1iZXIgZXJyb3JcbiIpOwoJCQlnb3RvIGVycm9yOwoJCX0KCgkJZm9yKGk9MDtpPGJs
b2NrX3NpemU7aSsrKQoJCXsKCQkJaWYoaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQs
IGZkXzM0LmRhdGFCYXNlKzIraSwgKihwX2RhdGEraSkpIDwgMCkgLy93cml0ZSBCbG9jayBEYXRh
CgkJCXsKCQkJCVNZTkFQSVRJQ1NfREVCVUcoIlJNSTRfd3JpdGVfaW1hZ2U6IGJsb2NrICVkIGRh
dGEgMHgleCBlcnJvclxuIixibG9ja19pbmRleCwqcF9kYXRhKTsKCQkJCWdvdG8gZXJyb3I7CgkJ
CX0KCQkJdWRlbGF5KDE1KTsKCQl9CgkJCgkJcF9kYXRhICs9IGJsb2NrX3NpemU7CQoKCQlpZihp
MmNfc21idXNfd3JpdGVfd29yZF9kYXRhKGNsaWVudCwgZmRfMzQuZGF0YUJhc2UrMTgsIHR5cGVf
Y21kKSA8IDApIC8vd3JpdGUgRmxhc2ggQ29udHJvbAoJCXsKCQkJU1lOQVBJVElDU19ERUJVRygi
aXNzdWUgd3JpdGUgY29tbWFuZCBlcnJvclxuIik7CgkJCWdvdG8gZXJyb3I7CgkJfQoKCQlpZihS
TUk0X3dhaXRfYXR0bihjbGllbnQsNSkgIT0gMCkKCQl7CgkJCWdvdG8gZXJyb3I7CgkJfQoJfQoK
CXJldHVybiAwOwplcnJvcjoKCXJldHVybiAtMTsKfQoKCnN0YXRpYyBpbnQgUk1JNF9wcm9ncmFt
X2NvbmZpZ3VyYXRpb24oc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCxjb25zdCB1bnNpZ25lZCBj
aGFyICpwZ21fZGF0YSApCnsKCWludCByZXQ7Cgl1bnNpZ25lZCBzaG9ydCBibG9ja19zaXplOwoJ
dW5zaWduZWQgc2hvcnQgdWlfYmxvY2tzOwoKCXByaW50aygiXG5STUk0IHByb2dyYW0gQ29uZmln
IGZpcm13YXJlLi4uXG4iKTsKCWJsb2NrX3NpemUgPSBpMmNfc21idXNfcmVhZF93b3JkX2RhdGEo
Y2xpZW50LGZkXzM0LnF1ZXJ5QmFzZSszKTsvL3JlYWQgQmxvY2sgU2l6ZSAwCgl1aV9ibG9ja3Mg
PSBpMmNfc21idXNfcmVhZF93b3JkX2RhdGEoY2xpZW50LGZkXzM0LnF1ZXJ5QmFzZSs1KTsJLy9y
ZWFkIEZpcm13YXJlIEJsb2NrIENvdW50IDAKCglpZihSTUk0X3dyaXRlX2ltYWdlKGNsaWVudCwg
MHgwNixwZ21fZGF0YSt1aV9ibG9ja3MqYmxvY2tfc2l6ZSApIDwgMCkKCXsKCQlTWU5BUElUSUNT
X0RFQlVHKCJ3cml0ZSBjb25maWd1cmUgaW1hZ2UgZXJyb3JcbiIpOwoJCXJldHVybiAtMTsKCX0K
CQoJcmV0ID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCxmZF8zNC5kYXRhQmFzZSsx
OCk7CS8vcmVhZCBGbGFzaCBDb250cm9sCglyZXR1cm4gKChyZXQgJiAweEYwKSA9PSAweDgwID8g
MCA6IHJldCk7Cn0KCnN0YXRpYyBpbnQgUk1JNF9wcm9ncmFtX2Zpcm13YXJlKHN0cnVjdCBpMmNf
Y2xpZW50ICpjbGllbnQsY29uc3QgdW5zaWduZWQgY2hhciAqcGdtX2RhdGEpCnsKCWludCByZXQ9
MDsKCXVuc2lnbmVkIHNob3J0IGJvb3Rsb2FkZXJfaWQ7CgoJcHJpbnRrKCJSTUk0IHByb2dyYW0g
VUkgZmlybXdhcmUuLi5cbiIpOwoKCWJvb3Rsb2FkZXJfaWQgPSBpMmNfc21idXNfcmVhZF93b3Jk
X2RhdGEoY2xpZW50LGZkXzM0LnF1ZXJ5QmFzZSk7CglpMmNfc21idXNfd3JpdGVfd29yZF9kYXRh
KGNsaWVudCxmZF8zNC5kYXRhQmFzZSsyLCBib290bG9hZGVyX2lkICk7IC8vd3JpdGUgQmxvY2sg
RGF0YTAKCglpZihpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwgZmRfMzQuZGF0YUJh
c2UrMTgsIDB4MDMpIDwgMCkgLy93cml0ZSBGbGFzaCBDb250cm9sCgl7CgkJU1lOQVBJVElDU19E
RUJVRygiUk1JNF9wcm9ncmFtX2Zpcm13YXJlIGVycm9yLCBlcmFzZSBmaXJtd2FyZSBlcnJvciBc
biIpOwoJCXJldHVybiAtMTsKCX0KCiAgICBtZGVsYXkoMTAwMCk7CgoJUk1JNF93YWl0X2F0dG4o
Y2xpZW50LDMwMCk7CgoJaWYoKHJldCA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQs
ZmRfMzQuZGF0YUJhc2UrMTgpKSAhPSAweDgwKSAvL2NoZWNrIEZsYXNoIENvbnRyb2wKCXsKCQly
ZXR1cm4gLTE7Cgl9CgoJaWYoIFJNSTRfd3JpdGVfaW1hZ2UoY2xpZW50LDB4MDIscGdtX2RhdGEp
IDwwICkKCXsKCQlTWU5BUElUSUNTX0RFQlVHKCJ3cml0ZSBVSSBmaXJtd2FyZSBlcnJvciFcbiIp
OwoJCXJldHVybiAtMTsKCX0KCglyZXQgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50
LGZkXzM0LmRhdGFCYXNlKzE4KTsgLy9yZWFkIEZsYXNoIENvbnRyb2wKCXJldHVybiAoKHJldCAm
IDB4RjApID09IDB4ODAgPyAwIDogcmV0KTsKfQoKc3RhdGljIGludCBzeW5hcHRpY3NfZG93bmxv
YWQoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCxjb25zdCB1bnNpZ25lZCBjaGFyICpwZ21fZGF0
YSkKewoJaW50IHJldDsKCglyZXQgPSBSTUk0X3JlYWRfUERUKGNsaWVudCk7CglpZihyZXQgIT0g
MCkKCXsKCQlwcmludGsoIlJNSSBwYWdlIGZ1bmMgY2hlY2sgZXJyb3JcbiIpOwoJCXJldHVybiAt
MTsKCX0KCglyZXQgPSBSTUk0X2VuYWJsZV9wcm9ncmFtKGNsaWVudCk7CglpZiggcmV0ICE9IDAp
Cgl7CgkJcHJpbnRrKCIlczolZDpSTUkgZW5hYmxlIHByb2dyYW0gZXJyb3IscmV0dXJuLi4uXG4i
LF9fRlVOQ1RJT05fXyxfX0xJTkVfXyk7CgkJZ290byBlcnJvcjsKCX0KCglyZXQgPSBSTUk0X2No
ZWNrX2Zpcm13YXJlKGNsaWVudCxwZ21fZGF0YSk7CglpZiggcmV0ICE9IDApCgl7CgkJcHJpbnRr
KCIlczolZDpSTUkgY2hlY2sgZmlybXdhcmUgZXJyb3IscmV0dXJuLi4uXG4iLF9fRlVOQ1RJT05f
XyxfX0xJTkVfXyk7CgkJZ290byBlcnJvcjsKCX0KCglyZXQgPSBSTUk0X3Byb2dyYW1fZmlybXdh
cmUoY2xpZW50LCBwZ21fZGF0YSArIDB4MTAwKTsKCWlmKCByZXQgIT0gMCkKCXsKCQlwcmludGso
IiVzOiVkOlJNSSBwcm9ncmFtIGZpcm13YXJlIGVycm9yLHJldHVybi4uLiIsX19GVU5DVElPTl9f
LF9fTElORV9fKTsKCQlnb3RvIGVycm9yOwoJfQoKCVJNSTRfcHJvZ3JhbV9jb25maWd1cmF0aW9u
KGNsaWVudCwgcGdtX2RhdGEgKyAgMHgxMDApOwoJcmV0dXJuIFJNSTRfZGlzYWJsZV9wcm9ncmFt
KGNsaWVudCk7CgplcnJvcjoKCVJNSTRfZGlzYWJsZV9wcm9ncmFtKGNsaWVudCk7CglwcmludGso
IiVzOiVkOmVycm9yLHJldHVybiAuLi4uIixfX0ZVTkNUSU9OX18sX19MSU5FX18pOwoJcmV0dXJu
IC0xOwoKfQoKc3RhdGljIGludCBpMmNfdXBkYXRlX2Zpcm13YXJlKHN0cnVjdCBpMmNfY2xpZW50
ICpjbGllbnQpIAp7CgljaGFyICpidWY7CglzdHJ1Y3QgZmlsZQkqZmlscDsKCXN0cnVjdCBpbm9k
ZSAqaW5vZGUgPSBOVUxMOwoJbW1fc2VnbWVudF90IG9sZGZzOwoJdWludDE2X3QJbGVuZ3RoOwoJ
aW50IHJldCA9IDA7Cgljb25zdCBjaGFyIGZpbGVuYW1lW109Ii9zZGNhcmQvdXBkYXRlL3N5bmFw
dGljcy5pbWciOwoKCW9sZGZzID0gZ2V0X2ZzKCk7CglzZXRfZnMoS0VSTkVMX0RTKTsKCWZpbHAg
PSBmaWxwX29wZW4oZmlsZW5hbWUsIE9fUkRPTkxZLCBTX0lSVVNSKTsKCWlmIChJU19FUlIoZmls
cCkpCgl7CiAgICAgICAgICAgIHByaW50aygiJXM6IGZpbGUgJXMgZmlscF9vcGVuIGVycm9yXG4i
LCBfX0ZVTkNUSU9OX18sZmlsZW5hbWUpOwogICAgICAgICAgICBzZXRfZnMob2xkZnMpOwogICAg
ICAgICAgICByZXR1cm4gLTE7Cgl9CgoJaWYgKCFmaWxwLT5mX29wKQoJewogICAgICAgICAgICBw
cmludGsoIiVzOiBGaWxlIE9wZXJhdGlvbiBNZXRob2QgRXJyb3JcbiIsIF9fRlVOQ1RJT05fXyk7
CiAgICAgICAgICAgIGZpbHBfY2xvc2UoZmlscCwgTlVMTCk7CiAgICAgICAgICAgIHNldF9mcyhv
bGRmcyk7CiAgICAgICAgICAgIHJldHVybiAtMTsKCX0KCiAgICBpbm9kZSA9IGZpbHAtPmZfcGF0
aC5kZW50cnktPmRfaW5vZGU7CiAgICBpZiAoIWlub2RlKSAKICAgIHsKICAgICAgICBwcmludGso
IiVzOiBHZXQgaW5vZGUgZnJvbSBmaWxwIGZhaWxlZFxuIiwgX19GVU5DVElPTl9fKTsKICAgICAg
ICBmaWxwX2Nsb3NlKGZpbHAsIE5VTEwpOwogICAgICAgIHNldF9mcyhvbGRmcyk7CiAgICAgICAg
cmV0dXJuIC0xOwogICAgfQoKICAgIGxlbmd0aCA9IGlfc2l6ZV9yZWFkKGlub2RlLT5pX21hcHBp
bmctPmhvc3QpOwogICAgaWYgKCEoIGxlbmd0aCA+IDAgJiYgbGVuZ3RoIDwgNjIqMTAyNCApKQog
ICAgewogICAgICAgIHByaW50aygiZmlsZSBzaXplIGVycm9yXG4iKTsKICAgICAgICBmaWxwX2Ns
b3NlKGZpbHAsIE5VTEwpOwogICAgICAgIHNldF9mcyhvbGRmcyk7CiAgICAgICAgcmV0dXJuIC0x
OwogICAgfQoKCWJ1ZiA9IHZtYWxsb2MobGVuZ3RoKyhsZW5ndGglMikpOwkJLyogYnVmIHNpemUg
aWYgZXZlbiAqLwoJaWYgKCFidWYpIAoJewoJCXByaW50aygiYWxsb2N0YXRpb24gbWVtb3J5IGZh
aWxlZFxuIik7CgkJZmlscF9jbG9zZShmaWxwLCBOVUxMKTsKCQlzZXRfZnMob2xkZnMpOwoJCXJl
dHVybiAtMTsKCX0KCiAgICBpZiAoZmlscC0+Zl9vcC0+cmVhZChmaWxwLCBidWYsIGxlbmd0aCwg
JmZpbHAtPmZfcG9zKSAhPSBsZW5ndGgpCiAgICB7CiAgICAgICAgcHJpbnRrKCIlczogZmlsZSBy
ZWFkIGVycm9yXG4iLCBfX0ZVTkNUSU9OX18pOwogICAgICAgIGZpbHBfY2xvc2UoZmlscCwgTlVM
TCk7CiAgICAgICAgc2V0X2ZzKG9sZGZzKTsKICAgICAgICB2ZnJlZShidWYpOwogICAgICAgIHJl
dHVybiAtMTsKICAgIH0KCglyZXQgPSBzeW5hcHRpY3NfZG93bmxvYWQoY2xpZW50LGJ1Zik7Cgog
CWZpbHBfY2xvc2UoZmlscCwgTlVMTCk7CglzZXRfZnMob2xkZnMpOwoJdmZyZWUoYnVmKTsKCXJl
dHVybiByZXQ7Cn0KCnN0YXRpYyBpbnQgdHNfZmlybXdhcmVfZmlsZSh2b2lkKQp7CglpbnQgcmV0
OwoJc3RydWN0IGtvYmplY3QgKmtvYmplY3RfdHM7Cglrb2JqZWN0X3RzID0ga29iamVjdF9jcmVh
dGVfYW5kX2FkZCgidG91Y2hfc2NyZWVuIiwgTlVMTCk7CglpZiAoIWtvYmplY3RfdHMpCgl7CgkJ
cHJpbnRrKCJjcmVhdGUga29iamV0Y3QgZXJyb3IhXG4iKTsKCQlyZXR1cm4gLTE7Cgl9CgkKCXJl
dCA9IHN5c2ZzX2NyZWF0ZV9maWxlKGtvYmplY3RfdHMsICZ1cGRhdGVfZmlybXdhcmVfYXR0cmli
dXRlLmF0dHIpOwoJaWYgKHJldCkgewoJCWtvYmplY3RfcHV0KGtvYmplY3RfdHMpOwoJCXByaW50
aygiY3JlYXRlIGZpbGUgZXJyb3JcbiIpOwoJCXJldHVybiAtMTsKCX0KCXJldHVybiAwOwkKfQoK
LyoKICogVGhlICJ1cGRhdGVfZmlybXdhcmUiIGZpbGUgd2hlcmUgYSBzdGF0aWMgdmFyaWFibGUg
aXMgcmVhZCBmcm9tIGFuZCB3cml0dGVuIHRvLgogKi8Kc3RhdGljIHNzaXplX3QgdXBkYXRlX2Zp
cm13YXJlX3Nob3coc3RydWN0IGtvYmplY3QgKmtvYmosIHN0cnVjdCBrb2JqX2F0dHJpYnV0ZSAq
YXR0cixjaGFyICpidWYpCnsKCXJldHVybiAxOwp9CgpzdGF0aWMgc3NpemVfdCB1cGRhdGVfZmly
bXdhcmVfc3RvcmUoc3RydWN0IGtvYmplY3QgKmtvYmosIHN0cnVjdCBrb2JqX2F0dHJpYnV0ZSAq
YXR0ciwgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCnsKCWNoYXIgcmV0ID0gLTE7CgoJ
cHJpbnRrKCIjIyMjIyMjIyMjIyMjIyMjI3VwZGF0ZV9maXJtd2FyZV9zdG9yZSMjIyMjIyMjIyMj
IyMjIyMjIyMjIyNcbiIpOwoKCWlmICggKGJ1ZlswXSA9PSAnMicpJiYoYnVmWzFdID09ICdcMCcp
ICkKCXsKCQkvKiBkcml2ZXIgZGV0ZWN0IGl0cyBkZXZpY2UgICovCgkJcmV0ID0gaTJjX3NtYnVz
X3JlYWRfYnl0ZV9kYXRhKGdfY2xpZW50LCBmZF8wMS5xdWVyeUJhc2UpOwoJCXByaW50aygiVGhl
IGlmIG9mIHN5bmFwdGljcyBkZXZpY2UgaXMgOiAlZFxuIixyZXQpOwoKCQlkaXNhYmxlX2lycShn
X2NsaWVudC0+aXJxKTsKCgkJLyp1cGRhdGUgZmlybXdhcmUqLwoJCXJldCA9IGkyY191cGRhdGVf
ZmlybXdhcmUoZ19jbGllbnQpOwoJCWVuYWJsZV9pcnEoZ19jbGllbnQtPmlycSk7CiAKCQlpZigg
MCAhPSByZXQgKQoJCXsKCQkJcHJpbnRrKCJVcGRhdGUgZmlybXdhcmUgZmFpbGVkIVxuIik7CgkJ
CXJldCA9IC0xOwoJCX0gCgkJZWxzZSAKCQl7CgkJCXByaW50aygiVXBkYXRlIGZpcm13YXJlIHN1
Y2Nlc3MhXG4iKTsKCQkJYXJtX3BtX3Jlc3RhcnQoMCwmcmV0KTsKCQkJcmV0ID0gMTsKCQl9Cgl9
CgkKCXJldHVybiByZXQ7CiB9CiNlbmRpZiAKCnN0YXRpYyBjb25zdCBzdHJ1Y3QgaTJjX2Rldmlj
ZV9pZCBzeW5hcHRpY3NfdHNfaWRbXSA9IHsKCXsgIlN5bmFwdGljc19ybWkiLCAwIH0sCgl7IH0K
fTsKc3RhdGljIHN0cnVjdCBpMmNfZHJpdmVyIHN5bmFwdGljc19ybWk0X2RyaXZlciA9IHsKCS5w
cm9iZQkJPSBzeW5hcHRpY3Nfcm1pNF9wcm9iZSwKCS5yZW1vdmUJCT0gc3luYXB0aWNzX3JtaTRf
cmVtb3ZlLAojaWZuZGVmIENPTkZJR19IQVNfRUFSTFlTVVNQRU5ECgkuc3VzcGVuZAk9IHN5bmFw
dGljc19ybWk0X3N1c3BlbmQsCgkucmVzdW1lCQk9IHN5bmFwdGljc19ybWk0X3Jlc3VtZSwKI2Vu
ZGlmCiAgICAuaWRfdGFibGUgICA9IHN5bmFwdGljc190c19pZCwKCS5kcml2ZXIgPSB7CgkJLm5h
bWUJPSAiU3luYXB0aWNzX3JtaSIsCgl9LAp9OwoKc3RhdGljIGludCBfX2RldmluaXQgc3luYXB0
aWNzX3JtaTRfaW5pdCh2b2lkKQp7CiAgICByZXR1cm4gaTJjX2FkZF9kcml2ZXIoJnN5bmFwdGlj
c19ybWk0X2RyaXZlcik7Cn0KCnN0YXRpYyB2b2lkIF9fZXhpdCBzeW5hcHRpY3Nfcm1pNF9leGl0
KHZvaWQpCnsKCWkyY19kZWxfZHJpdmVyKCZzeW5hcHRpY3Nfcm1pNF9kcml2ZXIpOwoJaWYgKHN5
bmFwdGljc193cSkKCQlkZXN0cm95X3dvcmtxdWV1ZShzeW5hcHRpY3Nfd3EpOwp9Cgptb2R1bGVf
aW5pdChzeW5hcHRpY3Nfcm1pNF9pbml0KTsKbW9kdWxlX2V4aXQoc3luYXB0aWNzX3JtaTRfZXhp
dCk7CgpNT0RVTEVfREVTQ1JJUFRJT04oIlN5bmFwdGljcyBSTUk0IERyaXZlciIpOwpNT0RVTEVf
TElDRU5TRSgiR1BMIik7Cgo=
--bcaec53aedb29d715404ea125d62--
